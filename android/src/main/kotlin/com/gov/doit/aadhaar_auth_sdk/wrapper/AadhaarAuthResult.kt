package com.gov.doit.aadhaar_auth_sdk.wrapper

data class AadhaarAuthResult(
    val isSuccess: Boolean,
    val errorCode: String? = null,
    val errorMessage: String? = null,
    val payload: String? = null
) {
    companion object {
        fun success(payload: String): AadhaarAuthResult {
            return AadhaarAuthResult(
                isSuccess = true,
                payload = payload
            )
        }

        fun failure(code: String, message: String): AadhaarAuthResult {
            return AadhaarAuthResult(
                isSuccess = false,
                errorCode = code,
                errorMessage = message
            )
        }
    }
}
