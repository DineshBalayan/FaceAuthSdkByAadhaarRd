package android.src.main.kotlin.com.gov.doit.aadhaar_auth_sdk.wrapper

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class AadhaarAuthFlutterActivity : FlutterActivity() {
    override fun getCachedEngineId() = "aadhaar_auth_engine"
}