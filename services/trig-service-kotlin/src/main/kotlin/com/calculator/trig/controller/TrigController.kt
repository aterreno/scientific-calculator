package com.calculator.trig.controller

import com.calculator.trig.model.TrigRequest
import com.calculator.trig.model.TrigResponse
import org.slf4j.LoggerFactory
import org.springframework.web.bind.annotation.*
import kotlin.math.*

@RestController
class TrigController {

    private val logger = LoggerFactory.getLogger(TrigController::class.java)

    @GetMapping("/health")
    fun healthCheck(): Map<String, String> {
        return mapOf("status" to "healthy")
    }

    @PostMapping("/sin")
    fun sin(@RequestBody request: TrigRequest): TrigResponse {
        val result = sin(request.a)
        logger.info("Sine: sin(${request.a}) = $result")
        return TrigResponse(result)
    }

    @PostMapping("/cos")
    fun cos(@RequestBody request: TrigRequest): TrigResponse {
        val result = cos(request.a)
        logger.info("Cosine: cos(${request.a}) = $result")
        return TrigResponse(result)
    }

    @PostMapping("/tan")
    fun tan(@RequestBody request: TrigRequest): TrigResponse {
        val result = tan(request.a)
        logger.info("Tangent: tan(${request.a}) = $result")
        return TrigResponse(result)
    }

    @PostMapping("/asin")
    fun asin(@RequestBody request: TrigRequest): TrigResponse {
        val result = asin(request.a)
        logger.info("Arc Sine: asin(${request.a}) = $result")
        return TrigResponse(result)
    }

    @PostMapping("/acos")
    fun acos(@RequestBody request: TrigRequest): TrigResponse {
        val result = acos(request.a)
        logger.info("Arc Cosine: acos(${request.a}) = $result")
        return TrigResponse(result)
    }

    @PostMapping("/atan")
    fun atan(@RequestBody request: TrigRequest): TrigResponse {
        val result = atan(request.a)
        logger.info("Arc Tangent: atan(${request.a}) = $result")
        return TrigResponse(result)
    }
}