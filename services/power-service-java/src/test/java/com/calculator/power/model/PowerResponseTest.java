package com.calculator.power.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

class PowerResponseTest {

    @Test
    @DisplayName("Should create a PowerResponse with default constructor")
    void testDefaultConstructor() {
        PowerResponse response = new PowerResponse();
        assertNotNull(response);
    }

    @Test
    @DisplayName("Should create a PowerResponse with parametrized constructor")
    void testParametrizedConstructor() {
        double result = 25.0;
        
        PowerResponse response = new PowerResponse(result);
        
        assertNotNull(response);
        assertEquals(result, response.getResult());
    }

    @Test
    @DisplayName("Should set and get result correctly")
    void testSetterAndGetter() {
        PowerResponse response = new PowerResponse();
        
        response.setResult(16.0);
        
        assertEquals(16.0, response.getResult());
    }
}