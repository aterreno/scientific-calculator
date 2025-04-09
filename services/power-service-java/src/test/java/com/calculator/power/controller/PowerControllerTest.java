package com.calculator.power.controller;

import com.calculator.power.model.PowerRequest;
import com.calculator.power.model.PowerResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;
import org.junit.jupiter.params.provider.ValueSource;

import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(PowerController.class)
public class PowerControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    @DisplayName("Health check endpoint should return healthy status")
    public void testHealthCheck() throws Exception {
        mockMvc.perform(get("/health"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON_VALUE))
                .andExpect(jsonPath("$.status").value("healthy"));
    }

    private static Stream<Arguments> powerTestCases() {
        return Stream.of(
            Arguments.of(2.0, 3.0, 8.0),          // Basic integer exponent
            Arguments.of(9.0, 0.5, 3.0),          // Square root
            Arguments.of(8.0, 1.0/3.0, 2.0),      // Cube root
            Arguments.of(10.0, 0.0, 1.0),         // Zero exponent
            Arguments.of(5.0, 1.0, 5.0),          // Identity
            Arguments.of(2.0, -2.0, 0.25),        // Negative exponent
            Arguments.of(0.0, 5.0, 0.0),          // Zero base
            Arguments.of(25.0, 0.5, 5.0),         // Perfect square
            Arguments.of(1000.0, 0.1, Math.pow(1000.0, 0.1))  // Arbitrary power (using exact Java calculation)
        );
    }
    
    @ParameterizedTest(name = "{0}^{1} = {2}")
    @MethodSource("powerTestCases")
    @DisplayName("Power calculation should return correct results for various inputs")
    public void testCalculatePower(double base, double exponent, double expected) throws Exception {
        PowerRequest request = new PowerRequest();
        request.setA(base);
        request.setB(exponent);

        MvcResult result = mockMvc.perform(post("/power")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.result").isNumber())
                .andReturn();

        PowerResponse response = objectMapper.readValue(
                result.getResponse().getContentAsString(), PowerResponse.class);
        if (base == 1000.0 && exponent == 0.1) {
            // For this specific case, we use exact comparison to what Java's Math.pow produces
            assertEquals(expected, response.getResult());
        } else {
            assertEquals(expected, response.getResult(), 0.001);
        }
    }

    private static Stream<Arguments> squareTestCases() {
        return Stream.of(
            Arguments.of(4.0, 16.0),    // Positive integer
            Arguments.of(-4.0, 16.0),   // Negative integer
            Arguments.of(0.0, 0.0),     // Zero
            Arguments.of(0.5, 0.25),    // Fraction
            Arguments.of(2.5, 6.25),    // Decimal
            Arguments.of(100.0, 10000.0) // Large number
        );
    }
    
    @ParameterizedTest(name = "{0}² = {1}")
    @MethodSource("squareTestCases")
    @DisplayName("Square calculation should return correct results for various inputs")
    public void testCalculateSquare(double input, double expected) throws Exception {
        PowerRequest request = new PowerRequest();
        request.setA(input);

        MvcResult result = mockMvc.perform(post("/square")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.result").isNumber())
                .andReturn();

        PowerResponse response = objectMapper.readValue(
                result.getResponse().getContentAsString(), PowerResponse.class);
        assertEquals(expected, response.getResult(), 0.001);
    }

    private static Stream<Arguments> cubeTestCases() {
        return Stream.of(
            Arguments.of(2.0, 8.0),      // Positive integer
            Arguments.of(-2.0, -8.0),    // Negative integer
            Arguments.of(0.0, 0.0),      // Zero
            Arguments.of(0.5, 0.125),    // Fraction
            Arguments.of(3.0, 27.0),     // Perfect cube
            Arguments.of(-3.0, -27.0)    // Negative perfect cube
        );
    }
    
    @ParameterizedTest(name = "{0}³ = {1}")
    @MethodSource("cubeTestCases")
    @DisplayName("Cube calculation should return correct results for various inputs")
    public void testCalculateCube(double input, double expected) throws Exception {
        PowerRequest request = new PowerRequest();
        request.setA(input);

        MvcResult result = mockMvc.perform(post("/cube")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.result").isNumber())
                .andReturn();

        PowerResponse response = objectMapper.readValue(
                result.getResponse().getContentAsString(), PowerResponse.class);
        assertEquals(expected, response.getResult(), 0.001);
    }
    
    @Test
    @DisplayName("Missing request body should return 400 Bad Request")
    public void testMissingRequestBody() throws Exception {
        mockMvc.perform(post("/power")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isBadRequest());
        
        mockMvc.perform(post("/square")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isBadRequest());
                
        mockMvc.perform(post("/cube")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isBadRequest());
    }
}