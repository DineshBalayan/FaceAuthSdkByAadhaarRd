package com.gov.doit.aadhaar_auth_sdk

import android.content.Context
import com.google.android.gms.tasks.Tasks.await
import com.google.android.play.core.integrity.IntegrityManagerFactory
import com.google.android.play.core.integrity.IntegrityTokenRequest

class PlayIntegrityManager(private val ctx: Context) {
    // Blocking request (called on background thread)
    fun requestIntegrityTokenBlocking(): String? {
        try {
            val integrityManager = IntegrityManagerFactory.create(ctx)
            val req = IntegrityTokenRequest.builder().build()
            val task = integrityManager.requestIntegrityToken(req)
            // Wait synchronously - only call from background thread
            val response = await(task)
            return response.token()
        } catch (e: Exception) {
            return null
        }
    }

/*
    val integrityManager = IntegrityManagerFactory.create(context)

    val request = IntegrityTokenRequest.builder()
        .setNonce(nonceFromServer)
        .build()

    integrityManager.requestIntegrityToken(request)
    .addOnSuccessListener { response ->
        val token = response.token()
        callback.onSuccess(token)
    }
    .addOnFailureListener { e ->
        callback.onError(e.message ?: "Integrity failed")
    }*/

}
