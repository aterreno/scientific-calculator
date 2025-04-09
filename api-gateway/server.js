const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { routeCalculation } = require('./routes');

const app = express();
const PORT = process.env.PORT || 8000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
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
  });
}

// Export for testing
module.exports = app;