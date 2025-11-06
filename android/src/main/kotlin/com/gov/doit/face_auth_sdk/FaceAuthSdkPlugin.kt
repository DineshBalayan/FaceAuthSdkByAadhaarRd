package com.gov.doit.face_auth_sdk

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.util.concurrent.Executors

class FaceAuthSdkPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    companion object {
        private const val TAG = "FaceAuthSdkPlugin"
        private const val CHANNEL = "face_auth_sdk"
    }

    private lateinit var channel: MethodChannel
    private var context: Context? = null
    private var activity: Activity? = null
    private var pendingResultForRD: MethodChannel.Result? = null
    private val executor = Executors.newSingleThreadExecutor()
    private val uiHandler = Handler(Looper.getMainLooper())

    private lateinit var faceRdLauncher: ActivityResultLauncher<Intent>

    // ----------------------------
    // FlutterPlugin lifecycle
    // ----------------------------
    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
    }

    // ----------------------------
    // ActivityAware lifecycle
    // ----------------------------
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        faceRdLauncher = binding.activity.registerForActivityResult(
            ActivityResultContracts.StartActivityForResult()
        ) { result ->
            val data = result.data
            val resultCallback = pendingResultForRD
            pendingResultForRD = null

            if (resultCallback == null) return@registerForActivityResult

            try {
                if (result.resultCode == Activity.RESULT_OK && data != null) {
                    // ✅ Use correct response key from RD app
                    val pidXml = data.getStringExtra("response") ?: ""
                    if (pidXml.isNotBlank()) {
                        resultCallback.success(pidXml)
                    } else {
                        resultCallback.error("EMPTY_PID", "PID XML is empty or null", null)
                    }
                } else {
                    val errCode = data?.getStringExtra("errorCode") ?: "RD_CANCELLED"
                    val errMsg = data?.getStringExtra("errorMessage") ?: "User cancelled or RD failed"
                    resultCallback.error(errCode, errMsg, null)
                }
            } catch (ex: Exception) {
                Log.e(TAG, "Face RD processing failed", ex)
                resultCallback.error("RD_RESULT_ERROR", ex.localizedMessage ?: ex.toString(), null)
            }
        }
    }

    override fun onDetachedFromActivity() { activity = null }
    override fun onDetachedFromActivityForConfigChanges() { activity = null }
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    // ----------------------------
    // MethodCall handler
    // ----------------------------
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            "startAuth" -> {
                val appId = call.argument<String>("appId") ?: ""
                val userData = call.argument<Map<String, Any>>("userData")
                startAuth(appId, userData, result)
            }
            "startFaceRD" -> {
                val rdPackage = call.argument<String>("rdPackage") ?: "com.gov.doitc.genericfacerd"
                val rdUriScheme = call.argument<String>("rdUriScheme") // optional fallback
                startFaceRD(rdPackage, rdUriScheme, result)
            }
            else -> result.notImplemented()
        }
    }

    // ----------------------------
    // startAuth (unchanged from your previous implementation)
    // ----------------------------
    private fun startAuth(appId: String, userData: Map<String, Any>?, result: MethodChannel.Result) {
        val ctx = context
        if (ctx == null) {
            result.error("NO_CONTEXT", "Plugin not attached to context", null)
            return
        }

        executor.execute {
            try {
                val packageName = ctx.packageName
                val signingCert = getSigningCertSha256(ctx)
                val deviceModel = android.os.Build.MODEL ?: ""
                val osVersion = android.os.Build.VERSION.RELEASE ?: ""

                val appInfo = JSONObject().apply {
                    put("packageName", packageName)
                    put("signingCertSha256", signingCert)
                    put("deviceModel", deviceModel)
                    put("osVersion", osVersion)
                }

                val attestationToken = obtainPlayIntegrityTokenPlaceholder()
                if (attestationToken == null) {
                    postError(result, "ATTESTATION_FAILED", "Could not obtain attestation token")
                    return@execute
                }

                val backendUrl = "https://your-backend.example.com/v1/auth/attest"
                val body = JSONObject().apply {
                    put("appId", appId)
                    put("appInfo", appInfo)
                    put("attestationToken", attestationToken)
                    if (userData != null) put("userData", JSONObject(userData))
                }

                val backendResp = postJson(backendUrl, body.toString(), mapOf("Content-Type" to "application/json"))

                if (backendResp == null) {
                    postError(result, "NETWORK_ERROR", "Failed to contact backend")
                    return@execute
                }

                val respJson = JSONObject(backendResp)
                if (respJson.optString("status") == "success" || respJson.has("client_token")) {
                    val clientToken = respJson.optString("client_token", respJson.optString("session_jwt", ""))
                    postSuccess(result, mapOf("status" to "success", "sessionToken" to clientToken, "rawResponse" to respJson.toString()))
                } else {
                    postError(result, "UNAUTHORIZED_APP", respJson.optString("error", "UNAUTHORIZED_APP"))
                }
            } catch (ex: Exception) {
                Log.e(TAG, "startAuth failed", ex)
                postError(result, "START_AUTH_ERROR", ex.localizedMessage ?: ex.toString())
            }
        }
    }

    // ----------------------------
    // startFaceRD with ActivityResultLauncher
    // ----------------------------
    private fun startFaceRD(rdPackage: String, rdUriScheme: String?, result: MethodChannel.Result) {
        val act = activity
        val ctx = context
        if (act == null || ctx == null) {
            result.error("NO_ACTIVITY", "Plugin not attached to an Activity", null)
            return
        }

        synchronized(this) {
            if (pendingResultForRD != null) {
                result.error("ALREADY_RUNNING", "Another RD flow is already running", null)
                return
            }
            pendingResultForRD = result
        }

        uiHandler.post {
            try {
                val launchIntent = ctx.packageManager.getLaunchIntentForPackage(rdPackage)
                if (launchIntent != null) {
                    launchIntent.putExtra("request_from_sdk", true)
                    faceRdLauncher.launch(launchIntent)
                } else if (!rdUriScheme.isNullOrEmpty()) {
                    val uri = Uri.parse(rdUriScheme)
                    val intent = Intent(Intent.ACTION_VIEW, uri)
                    intent.putExtra("request_from_sdk", true)
                    faceRdLauncher.launch(intent)
                } else {
                    synchronized(this) { pendingResultForRD = null }
                    postError(result, "RD_NOT_INSTALLED", "Aadhaar RD app not installed or cannot be launched")
                }
            } catch (e: Exception) {
                synchronized(this) { pendingResultForRD = null }
                postError(result, "RD_LAUNCH_FAILED", e.localizedMessage ?: "Failed to launch RD app")
            }
        }
    }

    // ----------------------------
    // Utilities
    // ----------------------------
    private fun postSuccess(result: MethodChannel.Result, map: Map<String, Any?>) {
        uiHandler.post { result.success(map) }
    }

    private fun postError(result: MethodChannel.Result, code: String, message: String) {
        uiHandler.post { result.error(code, message, null) }
    }

    private fun obtainPlayIntegrityTokenPlaceholder(): String? {
        val client = IntegrityManagerFactory.create(context)
        val request = IntegrityTokenRequest.builder().setNonce(nonce).build()
        val tokenResponse = client.requestIntegrityToken(request)
        val attestationToken = tokenResponse.token
        return attestationToken
    }

    private fun postJson(endpoint: String, body: String, headers: Map<String, String>): String? {
        // Your existing HTTP POST implementation
        return null
    }

    private fun getSigningCertSha256(ctx: Context): String {
        // Your existing certificate SHA256 implementation
        return ""
    }
}
