package com.gov.doit.face_auth_sdk.face_auth_sdk
package com.example.face_auth_sdk

import android.app.Activity
import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class FaceAuthSdkPlugin: FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "face_auth_sdk")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")

            "startFaceAuth" -> {
                launchRDService(result)
            }

            else -> result.notImplemented()
        }
    }

    private fun launchRDService(result: MethodChannel.Result) {
        try {
            // Example RD intent call (replace with your actual RD Service)
            val intent = Intent("in.gov.uidai.rdservice.face.CAPTURE")
            intent.putExtra("PID_OPTIONS", "<PidOptions ver='1.0' ...>")
            activity?.startActivityForResult(intent, 101)
            result.success(mapOf("status" to "started"))
        } catch (e: Exception) {
            result.error("LAUNCH_FAILED", e.message, null)
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {}
    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
