package com.gov.doit.aadhaar_auth_sdk.wrapper

import android.content.Context
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class AadhaarAuthLauncher : FlutterActivity() {

    companion object {
        private const val ENGINE_ID = "aadhaar_auth_engine"
        private const val CHANNEL_START = "aadhaar_auth_sdk/start"
        private const val CHANNEL_RESULT = "aadhaar_auth_sdk/result"
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        // 🔴 THIS MUST COME FROM FlutterEngineCache
        return FlutterEngineCache
            .getInstance()
            .get(ENGINE_ID)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val appCode = intent.getStringExtra("appCode") ?: ""
        val userData = intent.getStringExtra("userData") ?: ""

        Log.e("AADHAAR_AUTH_SDK", "AadhaarAuthLauncher called : $appCode : $userData")

        // Start Flutter flow
        MethodChannel(
            flutterEngine!!.dartExecutor.binaryMessenger,
            CHANNEL_START
        ).invokeMethod(
            "start",
            mapOf(
                "appCode" to appCode,
                "userData" to userData
            )
        )


        // Receive result from Flutter
        MethodChannel(
            flutterEngine!!.dartExecutor.binaryMessenger,
            CHANNEL_RESULT
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
