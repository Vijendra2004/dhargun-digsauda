package com.impiger.adaniwilmar.network_check

import okhttp3.ResponseBody
import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Streaming

interface GetDataService {
    @GET("api/lookups/netspeed")
    fun getNetSpeed() : Call<ResponseBody>
}