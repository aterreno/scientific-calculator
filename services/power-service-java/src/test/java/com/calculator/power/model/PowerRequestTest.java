package com.calculator.power.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

class PowerRequestTest {

    @Test
    @DisplayName("Should create a PowerRequest with default constructor")
    void testDefaultConstructor() {
        PowerRequest request = new PowerRequest();
        assertNotNull(request);
    }

    @Test
    @DisplayName("Should create a PowerRequest with parametrized constructor")
    void testParametrizedConstructor() {
        double a = 5.0;
        double b = 2.0;
        
        PowerRequest request = new PowerRequest(a, b);
        
        assertNotNull(request);
        assertEquals(a, request.getA());
        assertEquals(b, request.getB());
    }

    @Test
    @DisplayName("Should set and get values correctly")
    void testSettersAndGetters() {
        PowerRequest request = new PowerRequest();
        
        request.setA(10.0);
        request.setB(3.0);
        
        assertEquals(10.0, request.getA());
        assertEquals(3.0, request.getB());
    }
}