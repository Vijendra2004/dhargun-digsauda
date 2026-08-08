package com.impiger.adaniwilmar

interface UpdateRequestListener {
    fun onRequestCompleted(responseObject: Any?)

    fun onRequestFailed(responseObject: Any?)
}