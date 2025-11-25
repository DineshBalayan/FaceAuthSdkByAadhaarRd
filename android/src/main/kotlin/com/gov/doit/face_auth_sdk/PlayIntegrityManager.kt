package com.gov.doit.face_auth_sdk

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
}
