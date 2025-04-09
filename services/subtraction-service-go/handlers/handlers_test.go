package handlers

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func setupRouter() *gin.Engine {
	gin.SetMode(gin.TestMode)
	r := gin.Default()
	r.GET("/health", HealthCheckHandler)
	r.POST("/subtract", SubtractHandler)
	return r
}

func TestHealthCheckHandler(t *testing.T) {
	router := setupRouter()
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/health", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)

	var response HealthResponse
	err := json.Unmarshal(w.Body.Bytes(), &response)
	
	assert.Nil(t, err)
	assert.Equal(t, "healthy", response.Status)
}

func TestSubtractHandler(t *testing.T) {
	router := setupRouter()

	// Test case 1: Basic subtraction
	requestBody1 := SubtractionRequest{A: 5.0, B: 3.0}
	jsonBody1, _ := json.Marshal(requestBody1)
	
	w1 := httptest.NewRecorder()
	req1, _ := http.NewRequest("POST", "/subtract", bytes.NewBuffer(jsonBody1))
	req1.Header.Set("Content-Type", "application/json")
	router.ServeHTTP(w1, req1)
	
	assert.Equal(t, http.StatusOK, w1.Code)
	
	var response1 SubtractionResult
	err1 := json.Unmarshal(w1.Body.Bytes(), &response1)
	
	assert.Nil(t, err1)
	assert.Equal(t, 2.0, response1.Result)

	// Test case 2: Negative result
	requestBody2 := SubtractionRequest{A: 3.0, B: 5.0}
	jsonBody2, _ := json.Marshal(requestBody2)
	
	w2 := httptest.NewRecorder()
	req2, _ := http.NewRequest("POST", "/subtract", bytes.NewBuffer(jsonBody2))
	req2.Header.Set("Content-Type", "application/json")
	router.ServeHTTP(w2, req2)
	
	assert.Equal(t, http.StatusOK, w2.Code)
	
	var response2 SubtractionResult
	err2 := json.Unmarshal(w2.Body.Bytes(), &response2)
	
	assert.Nil(t, err2)
	assert.Equal(t, -2.0, response2.Result)

	// Test case 3: Decimal numbers
	requestBody3 := SubtractionRequest{A: 5.5, B: 3.3}
	jsonBody3, _ := json.Marshal(requestBody3)
	
	w3 := httptest.NewRecorder()
	req3, _ := http.NewRequest("POST", "/subtract", bytes.NewBuffer(jsonBody3))
	req3.Header.Set("Content-Type", "application/json")
	router.ServeHTTP(w3, req3)
	
	assert.Equal(t, http.StatusOK, w3.Code)
	
	var response3 SubtractionResult
	err3 := json.Unmarshal(w3.Body.Bytes(), &response3)
	
	assert.Nil(t, err3)
	assert.Equal(t, 2.2, response3.Result)
}