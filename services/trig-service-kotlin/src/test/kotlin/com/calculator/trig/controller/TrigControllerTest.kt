package com.calculator.trig.controller

import com.calculator.trig.model.TrigRequest
import com.calculator.trig.model.TrigResponse
import org.junit.jupiter.api.Test
import org.junit.jupiter.params.ParameterizedTest
import org.junit.jupiter.params.provider.CsvSource
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.status
import com.fasterxml.jackson.databind.ObjectMapper
import kotlin.math.*
import kotlin.test.assertEquals

@WebMvcTest(TrigController::class)
class TrigControllerTest {

    @Autowired
    private lateinit var mockMvc: MockMvc

    @Autowired
    private lateinit var objectMapper: ObjectMapper

    private val epsilon = 0.00001 // Tolerance for floating point comparisons

    @Test
    fun `healthCheck should return status healthy`() {
        mockMvc.perform(get("/health"))
            .andExpect(status().isOk)
            .andExpect(jsonPath("$.status").value("healthy"))
    }

    @ParameterizedTest
    @CsvSource(
        "0.0, 0.0",           // sin(0) = 0
        "1.5707963267949, 1.0", // sin(π/2) = 1
        "3.14159265359, 0.0"    // sin(π) = 0 (approximately)
    )
    fun `sin should return correct values`(input: Double, expected: Double) {
        val request = TrigRequest(input)
        val requestJson = objectMapper.writeValueAsString(request)

        mockMvc.perform(
            post("/sin")
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson)
        )
            .andExpect(status().isOk)
            .andExpect(jsonPath("$.result").isNumber)
            .andExpect { result ->
                val response = objectMapper.readValue(
                    result.response.contentAsString,
                    TrigResponse::class.java
                )
                assertEquals(expected, response.result, epsilon)
            }
    }

    @ParameterizedTest
    @CsvSource(
        "0.0, 1.0",           // cos(0) = 1
        "1.5707963267949, 0.0", // cos(π/2) = 0
        "3.14159265359, -1.0"   // cos(π) = -1
    )
    fun `cos should return correct values`(input: Double, expected: Double) {
        val request = TrigRequest(input)
        val requestJson = objectMapper.writeValueAsString(request)

        mockMvc.perform(
            post("/cos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson)
        )
            .andExpect(status().isOk)
            .andExpect(jsonPath("$.result").isNumber)
            .andExpect { result ->
                val response = objectMapper.readValue(
                    result.response.contentAsString,
                    TrigResponse::class.java
                )
                assertEquals(expected, response.result, epsilon)
            }
    }

    @ParameterizedTest
    @CsvSource(
        "0.0, 0.0",           // tan(0) = 0
        "0.7853981633974, 1.0"  // tan(π/4) = 1
    )
    fun `tan should return correct values`(input: Double, expected: Double) {
        val request = TrigRequest(input)
        val requestJson = objectMapper.writeValueAsString(request)

        mockMvc.perform(
            post("/tan")
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson)
        )
            .andExpect(status().isOk)
            .andExpect(jsonPath("$.result").isNumber)
            .andExpect { result ->
                val response = objectMapper.readValue(
                    result.response.contentAsString,
                    TrigResponse::class.java
                )
                assertEquals(expected, response.result, epsilon)
            }
    }

    @ParameterizedTest
    @CsvSource(
        "0.0, 0.0",        // asin(0) = 0
        "1.0, 1.5707963267949"  // asin(1) = π/2
    )
    fun `asin should return correct values`(input: Double, expected: Double) {
        val request = TrigRequest(input)
        val requestJson = objectMapper.writeValueAsString(request)

        mockMvc.perform(
            post("/asin")
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson)
        )
            .andExpect(status().isOk)
            .andExpect(jsonPath("$.result").isNumber)
            .andExpect { result ->
                val response = objectMapper.readValue(
                    result.response.contentAsString,
                    TrigResponse::class.java
                )
                assertEquals(expected, response.result, epsilon)
            }
    }

    @ParameterizedTest
    @CsvSource(
        "1.0, 0.0",        // acos(1) = 0
        "0.0, 1.5707963267949"  // acos(0) = π/2
    )
    fun `acos should return correct values`(input: Double, expected: Double) {
        val request = TrigRequest(input)
        val requestJson = objectMapper.writeValueAsString(request)

        mockMvc.perform(
            post("/acos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson)
        )
            .andExpect(status().isOk)
            .andExpect(jsonPath("$.result").isNumber)
            .andExpect { result ->
                val response = objectMapper.readValue(
                    result.response.contentAsString,
                    TrigResponse::class.java
                )
                assertEquals(expected, response.result, epsilon)
            }
    }

    @ParameterizedTest
    @CsvSource(
        "0.0, 0.0",        // atan(0) = 0
        "1.0, 0.7853981633974"  // atan(1) = π/4
    )
    fun `atan should return correct values`(input: Double, expected: Double) {
        val request = TrigRequest(input)
        val requestJson = objectMapper.writeValueAsString(request)

        mockMvc.perform(
            post("/atan")
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson)
        )
            .andExpect(status().isOk)
            .andExpect(jsonPath("$.result").isNumber)
            .andExpect { result ->
                val response = objectMapper.readValue(
                    result.response.contentAsString,
                    TrigResponse::class.java
                )
                assertEquals(expected, response.result, epsilon)
            }
    }
}