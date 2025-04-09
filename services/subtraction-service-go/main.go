package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"github.com/subtraction-service/handlers"
)

func main() {
	r := gin.Default()

	r.GET("/health", handlers.HealthCheckHandler)
	r.POST("/subtract", handlers.SubtractHandler)

	log.Println("Subtraction Service starting on port 8002")
	if err := r.Run(":8002"); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}