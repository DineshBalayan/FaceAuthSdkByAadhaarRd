package com.gov.doit.face_auth_sdk

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
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
        const val TAG = "FaceAuthSdkPlugin"
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

    // -------- FlutterPlugin lifecycle --------
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
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
        channel.setMethodCallHandler(null)
        context = null
    }

    // -------- ActivityAware lifecycle --------
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        activityBinding = binding
        // register activity result listener (plugin-safe)
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        // remove listener and clear refs
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
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
        activity = null
    }

    // -------- MethodChannel handler --------
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")

            "startAuth" -> {
                val appId = call.argument<String>("appId") ?: ""
                val userData = call.argument<Map<String, Any>>("userData")
                startAuth(appId, userData, result)
            }

            "startFaceRD" -> {
                val rdPackage = call.argument<String>("rdPackage") ?: "com.gov.doitc.genericfacerd"
                val rdUriScheme = call.argument<String>("rdUriScheme")
                startFaceRD(rdPackage, rdUriScheme, result)
            }

            "requestPlayIntegrity" -> requestPlayIntegrity(result)

            "isRdAppInstalled" -> result.success(isRdAppInstalled())

            "isJailBroken" -> result.success(Utils.isDeviceRooted())

            "exitApp" -> {
                result.success(null)
                activity?.finishAffinity()
            }

            else -> result.notImplemented()
        }
    }

    // -------- ActivityResultListener (handles RD response) --------
    // This is called on the platform thread when an activity returns a result.
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST_CODE_FACE_RD) return false

        val callback = pendingResultForRD
        pendingResultForRD = null

        if (callback == null) return false

        try {
            if (resultCode == Activity.RESULT_OK && data != null) {
                val pidXml = data.getStringExtra("response") ?: ""
                if (pidXml.isNotBlank()) {
                    callback.success(mapOf("status" to "success", "pid" to pidXml))
                } else {
                    callback.error("EMPTY_PID", "PID XML empty", null)
                }
            } else {
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

    private fun startAuth(appId: String, userData: Map<String, Any>?, result: MethodChannel.Result) {
        val ctx = context ?: run { result.error("NO_CONTEXT", "Plugin not attached", null); return }
        executor.execute {
            try {
                val cache = secureStorage.getIntegrityCache()
                val now = System.currentTimeMillis()
                if (cache != null && cache.isVerified && now < cache.validTillMillis) {
                    val backendResp = postCreateSessionUsingCache(appId, cache, userData)
                    if (backendResp != null) {
                        secureStorage.saveSessionJwt(backendResp.getString("sessionToken"))
                        result.success(mapOf(
                            "status" to "success",
                            "transactionId" to backendResp.optString("transactionId"),
                            "sessionToken" to backendResp.optString("sessionToken"),
                            "expiresAt" to backendResp.optLong("expiresAt", now + 600000)
                        ))
                        return@execute
                    }
                }

                val piToken = playManager.requestIntegrityTokenBlocking()
                if (piToken == null) {
                    result.error("ATTESTATION_FAILED", "Could not obtain attestation token", null)
                    return@execute
                }

                val verifyResp = postVerifyIntegrity(piToken, appId, userData)
                if (verifyResp == null) {
                    result.error("NETWORK_ERROR", "Failed contacting backend", null)
                    return@execute
                }

                if (verifyResp.optString("status") != "success") {
                    result.error("UNAUTHORIZED_APP", verifyResp.optString("error", "UNAUTHORIZED_APP"), null)
                    return@execute
                }

                val validTill = System.currentTimeMillis() + 24L * 60 * 60 * 1000
                val integrityHash = verifyResp.optString("integrityHash", "")
                secureStorage.saveIntegrityCache(true, validTill, integrityHash)

                val sessionResp = postCreateSessionUsingVerification(appId, verifyResp)
                if (sessionResp == null) {
                    result.error("SESSION_CREATE_FAILED", "Failed to create session", null)
                    return@execute
                }

                val sessionToken = sessionResp.optString("sessionToken", "")
                secureStorage.saveSessionJwt(sessionToken)
                result.success(mapOf(
                    "status" to "success",
                    "transactionId" to sessionResp.optString("transactionId"),
                    "sessionToken" to sessionToken,
                    "expiresAt" to sessionResp.optLong("expiresAt", System.currentTimeMillis() + 600000)
                ))

            } catch (ex: Exception) {
                Log.e(TAG, "startAuth failed", ex)
                result.error("START_AUTH_ERROR", ex.localizedMessage ?: ex.toString(), null)
            }
        }
    }

    private fun startFaceRD(rdPackage: String, rdUriScheme: String?, result: MethodChannel.Result) {
        val act = activity ?: run { result.error("NO_ACTIVITY", "Plugin not attached to Activity", null); return }
        if (pendingResultForRD != null) { result.error("ALREADY_RUNNING", "Another RD flow running", null); return }
        pendingResultForRD = result

        try {
            // Prefer launching package directly
            val launchIntent = context?.packageManager?.getLaunchIntentForPackage(rdPackage)
            if (launchIntent != null) {
                launchIntent.putExtra("request_from_sdk", true)
                act.startActivityForResult(launchIntent, REQUEST_CODE_FACE_RD)
                return
            }

            // Fallback to URI scheme if provided
            if (!rdUriScheme.isNullOrEmpty()) {
                val uri = Uri.parse(rdUriScheme)
                val intent = Intent(Intent.ACTION_VIEW, uri)
                intent.putExtra("request_from_sdk", true)
                act.startActivityForResult(intent, REQUEST_CODE_FACE_RD)
                return
            }

            // No way to launch RD
            pendingResultForRD = null
            result.error("RD_NOT_INSTALLED", "Aadhaar RD not installed", null)
        } catch (e: Exception) {
            pendingResultForRD = null
            result.error("RD_LAUNCH_FAILED", e.localizedMessage ?: e.toString(), null)
        }
    }

    private fun isRdAppInstalled(): Boolean {
        val ctx = context ?: return false
        val pm = ctx.packageManager
        val launch = pm.getLaunchIntentForPackage("com.gov.doitc.genericfacerd")
        return launch != null
    }

    private fun postVerifyIntegrity(piToken: String, appId: String, userData: Map<String, Any>?): JSONObject? {
        val endpoint = "https://your-backend.example.com/v1/auth/integrity/verify"
        val body = JSONObject().apply {
            put("appId", appId)
            put("integrityToken", piToken)
            if (userData != null) put("userData", JSONObject(userData))
        }
        return Utils.postJson(endpoint, body.toString())
    }

    private fun postCreateSessionUsingVerification(appId: String, verifyResp: JSONObject): JSONObject? {
        val endpoint = "https://your-backend.example.com/v1/auth/session/create"
        val body = JSONObject().apply {
            put("appId", appId)
            put("verifyResponse", verifyResp)
        }
        return Utils.postJson(endpoint, body.toString())
    }

    private fun postCreateSessionUsingCache(appId: String, cache: IntegrityCache?, userData: Map<String, Any>?): JSONObject? {
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
