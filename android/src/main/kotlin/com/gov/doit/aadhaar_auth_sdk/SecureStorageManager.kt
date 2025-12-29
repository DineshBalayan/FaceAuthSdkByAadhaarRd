package com.gov.doit.aadhaar_auth_sdk

import android.content.Context
import android.util.Base64
import org.json.JSONObject

class SecureStorageManager(private val ctx: Context) {
    private val prefs = ctx.getSharedPreferences("faceauth_secure", Context.MODE_PRIVATE)

    fun init() {
        SecureKeystore.createAesKeyIfNeeded()
    }

    private fun saveEncryptedString(key: String, value: String) {
        val (iv, enc) = SecureKeystore.encrypt(value.toByteArray(Charsets.UTF_8))
        prefs.edit()
            .putString("${key}_iv", Base64.encodeToString(iv, Base64.NO_WRAP))
            .putString("${key}_data", Base64.encodeToString(enc, Base64.NO_WRAP))
            .apply()
    }

    private fun readEncryptedString(key: String): String? {
        val ivB64 = prefs.getString("${key}_iv", null) ?: return null
        val encB64 = prefs.getString("${key}_data", null) ?: return null
        val iv = Base64.decode(ivB64, Base64.NO_WRAP)
        val enc = Base64.decode(encB64, Base64.NO_WRAP)
        val dec = SecureKeystore.decrypt(iv, enc)
        return String(dec, Charsets.UTF_8)
    }

    private fun clearKey(key: String) {
        prefs.edit().remove("${key}_iv").remove("${key}_data").apply()
    }
    fun savePlayIntegrityToken(token: String, ttlMillis: Long) {
        val obj = JSONObject().apply {
            put("token", token)
            put("validTill", ttlMillis)
        }
        saveEncryptedString("play_integrity_token", obj.toString())
    }

    fun getPlayIntegrityToken(): Pair<String, Long>? {
        val raw = readEncryptedString("play_integrity_token") ?: return null
        val obj = JSONObject(raw)
        return obj.optString("token") to obj.optLong("validTill")
    }

    // Integrity cache read/write (stored encrypted JSON)
    fun saveIntegrityCache(isVerified: Boolean, validTill: Long, integrityHash: String) {
        val obj = JSONObject().apply {
            put("isVerified", isVerified)
            put("validTill", validTill)
            put("integrityHash", integrityHash)
        }
        saveEncryptedString("pi_cache", obj.toString())
    }

    fun getIntegrityCache(): IntegrityCache? {
        val raw = readEncryptedString("pi_cache") ?: return null
        val obj = JSONObject(raw)
        return IntegrityCache(
            isVerified = obj.optBoolean("isVerified", false),
            validTillMillis = obj.optLong("validTill", 0L),
            integrityHash = obj.optString("integrityHash", "")
        )
    }

    fun saveSessionJwt(token: String) = saveEncryptedString("session_jwt", token)
    fun getSessionJwt(): String? = readEncryptedString("session_jwt")
    fun clearSession() {
        clearKey("session_jwt")
        clearKey("pi_cache")
    }

    fun putBool(key: String, value: Boolean) = prefs.edit().putBoolean(key, value).apply()
    fun getBool(key: String, def: Boolean = false) = prefs.getBoolean(key, def)
    fun putLong(key: String, value: Long) = prefs.edit().putLong(key, value).apply()
    fun getLong(key: String, def: Long = 0L) = prefs.getLong(key, def)
}
