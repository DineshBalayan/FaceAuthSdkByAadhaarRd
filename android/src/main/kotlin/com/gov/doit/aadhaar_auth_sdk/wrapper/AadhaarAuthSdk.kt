package com.gov.doit.aadhaar_auth_sdk.wrapper

import android.app.Activity
import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

object AadhaarAuthSdk {

    private const val ENGINE_ID = "aadhaar_auth_engine"
    private var flutterEngine: FlutterEngine? = null

    fun init(context: Context) {
        if (flutterEngine != null) return

        flutterEngine = FlutterEngine(context.applicationContext)

        // 🔴 VERY IMPORTANT
        flutterEngine!!.navigationChannel.setInitialRoute("/aadhaar_auth")

        flutterEngine!!.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine)
    }

    @JvmStatic
    fun launch(
        activity: Activity,
        appCode: String,
        userData: String
    ) {
        init(activity)

        val intent = FlutterActivity
            .withCachedEngine(ENGINE_ID)
            .build(activity)

        intent.putExtra("appCode", appCode)
        intent.putExtra("userData", userData)

        activity.startActivity(intent)
    }
}

