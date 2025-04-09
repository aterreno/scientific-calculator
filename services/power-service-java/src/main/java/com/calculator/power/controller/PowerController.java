package com.calculator.power.controller;

import com.calculator.power.model.PowerRequest;
import com.calculator.power.model.PowerResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
public class PowerController {

    private static final Logger logger = LoggerFactory.getLogger(PowerController.class);

    @GetMapping("/health")
    public @ResponseBody Map<String, String> healthCheck() {
        return Map.of("status", "healthy");
    }

    @PostMapping("/power")
    public PowerResponse calculatePower(@RequestBody PowerRequest request) {
        double base = request.getA();
        double exponent = request.getB();
        double result = Math.pow(base, exponent);
        
        logger.info("Power: {} ^ {} = {}", base, exponent, result);
        
        return new PowerResponse(result);
    }

    @PostMapping("/square")
    public PowerResponse calculateSquare(@RequestBody PowerRequest request) {
        double base = request.getA();
        double result = Math.pow(base, 2);
        
        logger.info("Square: {} ^ 2 = {}", base, result);
        
        return new PowerResponse(result);
    }

    @PostMapping("/cube")
    public PowerResponse calculateCube(@RequestBody PowerRequest request) {
        double base = request.getA();
        double result = Math.pow(base, 3);
        
        logger.info("Cube: {} ^ 3 = {}", base, result);
        
        return new PowerResponse(result);
    }
}