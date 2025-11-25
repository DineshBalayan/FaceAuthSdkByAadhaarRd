package com.gov.doit.face_auth_sdk

import org.json.JSONObject

data class IntegrityCache(
    val isVerified: Boolean,
    val validTillMillis: Long,
    val integrityHash: String
) {
    val isFresh: Boolean
        get() = System.currentTimeMillis() < validTillMillis

    companion object {
        fun fromJson(json: JSONObject): IntegrityCache {
            return IntegrityCache(
                isVerified = json.optBoolean("isVerified", false),
                validTillMillis = json.optLong("validTillMillis", 0L),
                integrityHash = json.optString("integrityHash", "")
            )
        }
    }

    fun toJson(): JSONObject {
        return JSONObject().apply {
            put("isVerified", isVerified)
            put("validTillMillis", validTillMillis)
            put("integrityHash", integrityHash)
        }
    }
}
