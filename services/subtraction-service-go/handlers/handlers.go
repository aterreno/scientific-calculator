package handlers

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

type SubtractionRequest struct {
	A float64 `json:"a"`
	B float64 `json:"b"`
}

type SubtractionResult struct {
	Result float64 `json:"result"`
}

type HealthResponse struct {
	Status string `json:"status"`
}

func HealthCheckHandler(c *gin.Context) {
	c.JSON(http.StatusOK, HealthResponse{
		Status: "healthy",
	})
}

func SubtractHandler(c *gin.Context) {
	var req SubtractionRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	result := req.A - req.B
	log.Printf("Subtraction: %f - %f = %f", req.A, req.B, result)

	c.JSON(http.StatusOK, SubtractionResult{
		Result: result,
	})
}