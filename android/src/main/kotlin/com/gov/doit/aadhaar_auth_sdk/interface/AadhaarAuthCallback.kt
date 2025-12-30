package com.gov.doit.aadhaar_auth_sdk.`interface`

import com.gov.doit.aadhaar_auth_sdk.wrapper.AadhaarAuthResult

interface AadhaarAuthCallback {
    fun onResult(result: AadhaarAuthResult)
}
