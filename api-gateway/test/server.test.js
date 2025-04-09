// Mock the routes module before requiring the app
jest.mock('../routes', () => ({
  routeCalculation: jest.fn(),
  getServices: jest.fn(),
  setServices: jest.fn()
}));

const request = require('supertest');
const app = require('../server');
const routesModule = require('../routes');

describe('API Gateway Server', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('Health Endpoint', () => {
    test('should respond with healthy status', async () => {
      const response = await request(app).get('/health');
      
      expect(response.status).toBe(200);
      expect(response.body).toEqual({ status: 'healthy' });
    });
  });

  describe('Calculate Endpoint', () => {
    test('should correctly route valid calculation requests', async () => {
      routesModule.routeCalculation.mockResolvedValue({ result: 5 });
      
      const response = await request(app)
        .post('/calculate')
        .send({ operation: 'add', a: 2, b: 3 });
      
      expect(response.status).toBe(200);
      expect(response.body).toEqual({ result: 5 });
      expect(routesModule.routeCalculation).toHaveBeenCalledWith('add', { a: 2, b: 3 });
    });

    test('should return 400 if operation is missing', async () => {
      const response = await request(app)
        .post('/calculate')
        .send({ a: 2, b: 3 });
      
      expect(response.status).toBe(400);
      expect(response.body).toHaveProperty('error', 'Operation parameter is required');
      expect(routesModule.routeCalculation).not.toHaveBeenCalled();
    });

    test('should return 400 for unsupported operations', async () => {
      routesModule.routeCalculation.mockRejectedValue(new Error('Unsupported operation: invalid'));
      
      const response = await request(app)
        .post('/calculate')
        .send({ operation: 'invalid', a: 2, b: 3 });
      
      expect(response.status).toBe(400);
      expect(response.body).toHaveProperty('error', 'Unsupported operation: invalid');
    });

    test('should return 500 for service unavailability', async () => {
      routesModule.routeCalculation.mockRejectedValue(new Error('Network error'));
      
      const response = await request(app)
        .post('/calculate')
        .send({ operation: 'add', a: 2, b: 3 });
      
      expect(response.status).toBe(500);
      expect(response.body).toHaveProperty('error', 'Service unavailable');
      expect(response.body).toHaveProperty('details', 'Network error');
    });
  });
});