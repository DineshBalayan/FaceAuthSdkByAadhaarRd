package com.gov.doit.aadhaar_auth_sdk.wrapper

import AadhaarAuthCallbackHolder
import android.app.Activity
import android.content.Intent
import android.content.Context
import com.gov.doit.aadhaar_auth_sdk.`interface`.AadhaarAuthCallback
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.android.FlutterActivity

class AadhaarAuthSdk private constructor() {

    companion object {
        @JvmStatic
        val instance: AadhaarAuthSdk by lazy { AadhaarAuthSdk() }
        lateinit var flutterEngine: FlutterEngine
        private var initialized = false

        fun initSdk(context: Context) {
            if (!initialized) {
                flutterEngine = FlutterEngine(context.applicationContext)
                flutterEngine.dartExecutor.executeDartEntrypoint(
                    DartExecutor.DartEntrypoint.createDefault()
                )

                FlutterEngineCache
                    .getInstance()
                    .put("face_auth_engine", flutterEngine)

                initialized = true
            }
        }
    }

    fun launchAuthPlateform(
        activity: Activity,
        appCode: String,
        userData: String,
        callback: AadhaarAuthCallback
    ) {
        if (!initialized) initSdk(activity.applicationContext)

        AadhaarAuthCallbackHolder.callback = callback
        val intent = FlutterActivity
            .withCachedEngine("aadhaar_auth_engine")
            .build(activity)
        intent.putExtra("appCode", appCode)
        intent.putExtra("userData", userData)

        activity.startActivity(intent)
    }
}
