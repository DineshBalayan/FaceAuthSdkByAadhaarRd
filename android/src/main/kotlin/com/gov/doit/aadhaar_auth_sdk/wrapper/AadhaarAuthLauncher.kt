package com.gov.doit.aadhaar_auth_sdk.wrapper

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class AadhaarAuthLauncher : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "aadhaar_auth_sdk/start"
        ).invokeMethod(
            "start",
            mapOf(
                "appCode" to intent.getStringExtra("appCode"),
                "userData" to intent.getStringExtra("userData")
            )
        )

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "aadhaar_auth_sdk/result"
        ).setMethodCallHandler { call, result ->
            when (call.method) {

                "finishSuccess" -> {
                    val data = call.argument<String>("data")
                    AadhaarAuthCallbackHolder.callback?.onResult(
                        AadhaarAuthResult.success(data ?: "")
                    )
                    AadhaarAuthCallbackHolder.callback = null
                    finish()
                    result.success(null)
                }

                "finishFailure" -> {
                    val code = call.argument<String>("code") ?: "UNKNOWN"
                    val msg = call.argument<String>("message") ?: "Error"
                    AadhaarAuthCallbackHolder.callback?.onResult(
                        AadhaarAuthResult.failure(code, msg)
                    )
                    AadhaarAuthCallbackHolder.callback = null
                    finish()
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }
}
