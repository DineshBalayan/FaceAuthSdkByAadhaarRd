package com.gov.doit.face_auth_sdk

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Log
import org.json.JSONObject
import java.util.concurrent.Executors
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class FaceAuthSdkPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {

    companion object {
        const val CHANNEL = "face_auth_sdk"
        const val TAG = "PLUGIN ACTIVITY"
        private const val REQUEST_CODE_FACE_RD = 0xCAFE  // arbitrary unique request code
    }

    private lateinit var channel: MethodChannel
    private var context: Context? = null
    private var activity: Activity? = null
    private var activityBinding: ActivityPluginBinding? = null
    private var pendingResultForRD: MethodChannel.Result? = null
    private val executor = Executors.newSingleThreadExecutor()
    private lateinit var secureStorage: SecureStorageManager
    private lateinit var playManager: PlayIntegrityManager

    private var pidOptionsXml: String? = null

    // -------- FlutterPlugin lifecycle --------
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onAttachedToEngine called")
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)

        context?.let {
            secureStorage = SecureStorageManager(it)
            playManager = PlayIntegrityManager(it)
            executor.execute { secureStorage.init() } // initialize keystore async
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onDetachedFromEngine called")
        channel.setMethodCallHandler(null)
        context = null
    }

    // -------- ActivityAware lifecycle --------
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d(TAG, "onAttachedToActivity called")
        activity = binding.activity
        activityBinding = binding
        // register activity result listener (plugin-safe)
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        activityBinding = binding
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        Log.d(TAG, "onDetachedFromActivity called")
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
        activity = null
    }

    // -------- MethodChannel handler --------
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d(TAG, "onMethodCall method=${call.method} arguments=${call.arguments}")
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${Build.VERSION.RELEASE}")

            "startAuth" -> {
                val appId = call.argument<String>("appId") ?: ""
                val userData = call.argument<Map<String, Any>>("userData")
                startAuth(appId, userData, result)
            }

            "startFaceRD" -> {
                pidOptionsXml = call.argument<String>("pidOptions")
                pendingResultForRD = result
                startFaceRD()
            }

            "requestPlayIntegrity" -> requestPlayIntegrity(result)

            "isRdAppInstalled" -> {
                val packageName = call.argument<String>("packageName")
                val checkPkg = packageName ?: "in.gov.uidai.facerd"
                result.success(isRdAppInstalled(checkPkg))
            }

            "isJailBroken" -> result.success(Utils.isDeviceRooted())

            "exitApp" -> {
                result.success(null)
                activity?.finishAffinity()
            }

            else -> result.notImplemented()
        }
    }

    // -------- ActivityResultListener (handles RD response) --------
    // Called on the platform thread when an activity returns a result.
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST_CODE_FACE_RD) return false

        val callback = pendingResultForRD
        pendingResultForRD = null

        if (callback == null) return false
        Log.d(TAG, "callback != null")
        try {
            if (resultCode == Activity.RESULT_OK && data != null) {
                Log.d(TAG, "resultCode == Activity.RESULT_OK && data != null")
                val pidXml = data.getStringExtra("response") ?: ""
                if (pidXml.isNotBlank()) {
                    Log.d(TAG, "pid success callback+  $pidXml")
                    callback.success(pidXml)
                } else {
                    Log.d(TAG, "pid error callback")
                    callback.error("EMPTY_PID", "PID XML empty", null)
                }
            } else {
                Log.d(TAG, "Else - resultCode == Activity.RESULT_OK && data != null")
                val code = data?.getStringExtra("errorCode") ?: "RD_CANCELLED"
                val msg = data?.getStringExtra("errorMessage") ?: "User cancelled or RD failed"
                callback.error(code, msg, null)
            }
        } catch (ex: Exception) {
            Log.e(TAG, "RD result handling failed", ex)
            callback.error("RD_RESULT_ERROR", ex.localizedMessage ?: ex.toString(), null)
        }

        return true
    }

    // -------- Core logic helpers --------
    private fun startAuth(
        appId: String,
        userData: Map<String, Any>?,
        result: MethodChannel.Result
    ) {
        val ctx = context ?: run {
            result.error("NO_CONTEXT", "Plugin not attached", null)
            return
        }
       /* try {
            executor.execute {

                // STEP 1 → Request Play Integrity Token
                val piToken = playManager.requestIntegrityTokenBlocking()
                if (piToken == null) {
                    result.error("PI_ERROR", "Failed to get Play Integrity Token", null)
                    return@execute
                }

                // STEP 2 → POST to Backend: /auth/integrity/verify
                val verifyResp = postVerifyIntegrity(piToken, appId, userData)
                if (verifyResp == null || !verifyResp.optBoolean("success", false)) {
                    result.error(
                        "VERIFY_FAILED",
                        verifyResp?.optString("message") ?: "Integrity verification failed",
                        verifyResp?.toString()
                    )
                    return@execute
                }

                // Extract cache TTL
                val cacheTTL = verifyResp.optLong("cacheTTL", 0L)

                // Save token+TTL securely
                secureStorage.savePlayIntegrityToken(piToken, cacheTTL)
                // STEP 3 → Create Session using verify response
                val sessionResp = postCreateSessionUsingVerification(appId, verifyResp)

                if (sessionResp == null || !sessionResp.optBoolean("success", false)) {
                    result.error(
                        "SESSION_CREATE_FAILED",
                        sessionResp?.optString("message") ?: "Session creation failed",
                        sessionResp?.toString()
                    )
                    return@execute
                }

                // FINAL OUTPUT → Return session response directly to Flutter
                val response = mapOf(
                    "status" to "success",
                    "session" to sessionResp.toString()
                )

                result.success(response)
            }
        } catch (e: Exception) {
            result.error("START_AUTH_EXCEPTION", e.localizedMessage, null)
        }*/
        // Simple device info
        val packageName = ctx.packageName
        val deviceId = Settings.Secure.getString(ctx.contentResolver, Settings.Secure.ANDROID_ID)
        val deviceModel = Build.MODEL
        val androidVersion = Build.VERSION.RELEASE

        val responseData = mapOf(
            "packageName" to packageName,
            "deviceId" to deviceId,
            "deviceModel" to deviceModel,
            "androidVersion" to androidVersion
        )

        // Return dummy auth result with device info
        result.success(
            mapOf(
                "status" to "success",
                "transactionId" to "DUMMY_TXN_123",
                "sessionToken" to "DUMMY_SESSION_TOKEN",
                "expiresAt" to System.currentTimeMillis() + 600_000,  // +10 minutes
                "responseData" to responseData
            )
        )
    }

    private fun startFaceRD() {
        try {
            val act = activity ?: run {
                pendingResultForRD?.error("NO_ACTIVITY", "Plugin not attached to Activity", null)
                pendingResultForRD = null
                Log.d(TAG, "startFaceRD return NO_ACTIVITY Plugin not attached to Activity")
                return
            }

            val intent = Intent("in.gov.uidai.rdservice.face.CAPTURE")

            // UIDAI RD standard expects "request" extra (use appropriate key for your RD)
            if (!pidOptionsXml.isNullOrBlank()) {
                intent.putExtra("request", pidOptionsXml)

                Log.d(TAG,"pidOptionsXml added not null :- $pidOptionsXml")
            }

            // chooser (if multiple RD apps) and start for result
            val chooser = Intent.createChooser(intent, "Select Face RD App")
            act.startActivityForResult(chooser, REQUEST_CODE_FACE_RD)
            Log.d(TAG,"RD APP Chooser Launched")
        } catch (e: Exception) {
            Log.e(TAG, "startFaceRD failed", e)
            pendingResultForRD?.error("RD_LAUNCH_FAILED", e.localizedMessage ?: e.toString(), null)
            pendingResultForRD = null
        }
    }

    private fun isRdAppInstalled(checkPackage: String): Boolean {
        val ctx = context ?: run {
            Log.d(TAG, "isRdAppInstalled: context is null")
            return false
        }

        return try {
            Log.d(TAG, "Checking package visibility for: $checkPackage")
            val pm = ctx.packageManager
            pm.getPackageInfo(checkPackage, PackageManager.GET_ACTIVITIES)
            Log.d(TAG, "Package $checkPackage found")
            true
        } catch (e: PackageManager.NameNotFoundException) {
            Log.d(TAG, "Package $checkPackage NOT found")
            false
        } catch (e: Exception) {
            Log.e(TAG, "Error checking package $checkPackage", e)
            false
        }
    }

    private fun postVerifyIntegrity(
        piToken: String,
        appId: String,
        userData: Map<String, Any>?
    ): JSONObject? {
        val endpoint = "https://your-backend.example.com/v1/auth/integrity/verify"
        val body = JSONObject().apply {
            put("appId", appId)
            put("integrityToken", piToken)
            if (userData != null) put("userData", JSONObject(userData))
        }
        return Utils.postJson(endpoint, body.toString())
    }

    private fun postCreateSessionUsingVerification(
        appId: String,
        verifyResp: JSONObject
    ): JSONObject? {
        val endpoint = "https://your-backend.example.com/v1/auth/session/create"
        val body = JSONObject().apply {
            put("appId", appId)
            put("verifyResponse", verifyResp)
        }
        return Utils.postJson(endpoint, body.toString())
    }

    private fun postCreateSessionUsingCache(
        appId: String,
        cache: IntegrityCache?,
        userData: Map<String, Any>?
    ): JSONObject? {
        val endpoint = "https://your-backend.example.com/v1/auth/session/create"
        val body = JSONObject().apply {
            put("appId", appId)
            put("useCache", true)
            if (userData != null) put("userData", JSONObject(userData))
        }
        return Utils.postJson(endpoint, body.toString())
    }

    private fun requestPlayIntegrity(result: MethodChannel.Result) {
        executor.execute {
            try {
                val token = playManager.requestIntegrityTokenBlocking()
                if (token == null) result.error("TOKEN_ERROR", "Failed to get token", null)
                else result.success(token)
            } catch (e: Exception) {
                result.error("TOKEN_ERROR", e.localizedMessage ?: e.toString(), null)
            }
        }
    }
}
