const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { routeCalculation, getServices } = require('./routes');

const app = express();
const PORT = process.env.PORT || 8000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

// Debugging endpoint to see environment variables and service URLs
app.get('/debug', (req, res) => {
  // Only enable in development or when explicitly allowed
  if (process.env.ENABLE_DEBUG === 'true' || process.env.NODE_ENV === 'development') {
    const debugInfo = {
      environment: process.env.NODE_ENV || 'not set',
      serviceUrls: getServices(),
      environmentVariables: {
        ADDITION_SERVICE_URL: process.env.ADDITION_SERVICE_URL || 'not set',
        SUBTRACTION_SERVICE_URL: process.env.SUBTRACTION_SERVICE_URL || 'not set',
        MULTIPLICATION_SERVICE_URL: process.env.MULTIPLICATION_SERVICE_URL || 'not set',
        DIVISION_SERVICE_URL: process.env.DIVISION_SERVICE_URL || 'not set',
        POWER_SERVICE_URL: process.env.POWER_SERVICE_URL || 'not set',
        SQUARE_ROOT_SERVICE_URL: process.env.SQUARE_ROOT_SERVICE_URL || 'not set',
        LOG_SERVICE_URL: process.env.LOG_SERVICE_URL || 'not set',
        TRIG_SERVICE_URL: process.env.TRIG_SERVICE_URL || 'not set',
        MEMORY_SERVICE_URL: process.env.MEMORY_SERVICE_URL || 'not set',
        FACTORIAL_SERVICE_URL: process.env.FACTORIAL_SERVICE_URL || 'not set',
        CONVERSION_SERVICE_URL: process.env.CONVERSION_SERVICE_URL || 'not set',
        MATRIX_SERVICE_URL: process.env.MATRIX_SERVICE_URL || 'not set',
        BITWISE_SERVICE_URL: process.env.BITWISE_SERVICE_URL || 'not set',
        COMPLEX_SERVICE_URL: process.env.COMPLEX_SERVICE_URL || 'not set'
      }
    };
    res.json(debugInfo);
  } else {
    res.status(403).json({ error: 'Debug endpoint disabled in production' });
  }
});

// Calculate endpoint - routes to appropriate service based on operation
app.post('/calculate', async (req, res) => {
  const { operation, ...params } = req.body;
  
  if (!operation) {
    return res.status(400).json({ error: 'Operation parameter is required' });
  }
  
  try {
    const result = await routeCalculation(operation, params);
    res.json(result);
  } catch (error) {
    console.error('Error forwarding request:', error.message);
    
    // Determine appropriate status code
    const statusCode = error.message.includes('Unsupported') ? 400 : 500;
    
    res.status(statusCode).json({ 
      error: statusCode === 400 ? error.message : 'Service unavailable', 
      details: error.message 
    });
  }
});

// Only start the server if this file is run directly
if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`API Gateway running on port ${PORT}`);
    console.log('Available services:');
    console.log(JSON.stringify(getServices(), null, 2));  
  });
}

// Export for testing
module.exports = app;