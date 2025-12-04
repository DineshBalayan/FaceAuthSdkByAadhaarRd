package com.gov.doit.face_auth_sdk

import android.util.Log
import org.json.JSONObject
import java.io.BufferedOutputStream
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.util.Base64
import java.security.MessageDigest


object Utils {
    fun postJson(endpoint: String, body: String): JSONObject? {
        try {
            val url = URL(endpoint)
            val con = (url.openConnection() as HttpURLConnection).apply {
                requestMethod = "POST"
                setRequestProperty("Content-Type", "application/json")
                doOutput = true
                connectTimeout = 15000
                readTimeout = 15000
            }
            BufferedOutputStream(con.outputStream).use { it.write(body.toByteArray()) }
            val code = con.responseCode
            val input = if (code in 200..299) con.inputStream else con.errorStream
            val sb = StringBuilder()
            BufferedReader(InputStreamReader(input)).use { r ->
                var line = r.readLine()
                while (line != null) {
                    sb.append(line)
                    line = r.readLine()
                }
            }
            return JSONObject(sb.toString())
        } catch (e: Exception) {
            Log.w("Utils", "postJson failed", e)
            return null
        }
    }

    fun sha256Base64(input: ByteArray): String {
        val md = MessageDigest.getInstance("SHA-256")
        val digest = md.digest(input)
        return Base64.encodeToString(digest, Base64.NO_WRAP)
    }

    fun getSigningCertSha256(ctx: Context): String {
        return try {
            val pm = ctx.packageManager
            val pkg = ctx.packageName

            val bytes: ByteArray? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                val sign = pm.getPackageInfo(pkg, PackageManager.GET_SIGNING_CERTIFICATES)
                sign.signingInfo?.apkContentsSigners?.firstOrNull()?.toByteArray()
            } else {
                val sign = pm.getPackageInfo(pkg, PackageManager.GET_SIGNATURES)
                sign.signatures?.firstOrNull()?.toByteArray()
            }

            if (bytes != null) {
                val md = MessageDigest.getInstance("SHA-256").digest(bytes)
                Base64.encodeToString(md, Base64.NO_WRAP)
            } else {
                ""
            }
        } catch (e: Exception) {
            ""
        }
    }


    // Root detection small helper (very basic)
    fun isDeviceRooted(): Boolean {
        val paths = arrayOf(
            "/system/app/Superuser.apk",
            "/sbin/su",
            "/system/bin/su",
            "/system/xbin/su",
            "/data/local/xbin/su",
            "/data/local/bin/su",
            "/system/sd/xbin/su"
        )
        for (p in paths) {
            if (java.io.File(p).exists()) return true
        }
        return false
    }
}
