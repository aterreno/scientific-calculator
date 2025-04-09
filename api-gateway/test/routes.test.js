// Import the real axios module (don't use jest.mock, we'll use MockAdapter instead)
const axios = require('axios');
const MockAdapter = require('axios-mock-adapter');

// Create a mock for axios
const mock = new MockAdapter(axios);

// Import routes
const { routeCalculation, getServices, setServices } = require('../routes');

describe('Routes Module', () => {
  beforeEach(() => {
    // Reset axios mocks before each test
    mock.reset();
    
    // Setup mock services
    const mockServices = {
      addition: 'http://mock-addition:8001',
      subtraction: 'http://mock-subtraction:8002',
      multiplication: 'http://mock-multiplication:8003',
      division: 'http://mock-division:8004',
      power: 'http://mock-power:8005',
      squareRoot: 'http://mock-sqrt:8006',
      logarithm: 'http://mock-log:8007',
      trigonometry: 'http://mock-trig:8008',
      memory: 'http://mock-memory:8009',
      factorial: 'http://mock-factorial:8010',
      conversion: 'http://mock-conversion:8012',
      matrix: 'http://mock-matrix:8014',
      bitwise: 'http://mock-bitwise:8016',
      complex: 'http://mock-complex:8017'
    };
    
    // Set the mock services
    setServices(mockServices);
  });

  afterEach(() => {
    // Reset services after each test
    jest.clearAllMocks();
  });

  describe('Basic Arithmetic Operations', () => {
    test('should route addition requests correctly', async () => {
      // Setup mock response
      mock.onPost('http://mock-addition:8001/add').reply(200, { result: 5 });
      
      // Call the function
      const result = await routeCalculation('add', { a: 2, b: 3 });
      
      // Assertions
      expect(result).toEqual({ result: 5 });
      expect(mock.history.post[0].url).toBe('http://mock-addition:8001/add');
      expect(JSON.parse(mock.history.post[0].data)).toEqual({ a: 2, b: 3 });
    });

    test('should route subtraction requests correctly', async () => {
      mock.onPost('http://mock-subtraction:8002/subtract').reply(200, { result: 2 });
      
      const result = await routeCalculation('subtract', { a: 5, b: 3 });
      
      expect(result).toEqual({ result: 2 });
      expect(mock.history.post[0].url).toBe('http://mock-subtraction:8002/subtract');
      expect(JSON.parse(mock.history.post[0].data)).toEqual({ a: 5, b: 3 });
    });

    test('should route multiplication requests correctly', async () => {
      mock.onPost('http://mock-multiplication:8003/multiply').reply(200, { result: 15 });
      
      const result = await routeCalculation('multiply', { a: 5, b: 3 });
      
      expect(result).toEqual({ result: 15 });
      expect(mock.history.post[0].url).toBe('http://mock-multiplication:8003/multiply');
    });

    test('should route division requests correctly', async () => {
      mock.onPost('http://mock-division:8004/divide').reply(200, { result: 2 });
      
      const result = await routeCalculation('divide', { a: 6, b: 3 });
      
      expect(result).toEqual({ result: 2 });
      expect(mock.history.post[0].url).toBe('http://mock-division:8004/divide');
    });
  });

  describe('Advanced Mathematical Operations', () => {
    test('should route power operation correctly', async () => {
      mock.onPost('http://mock-power:8005/power').reply(200, { result: 8 });
      
      const result = await routeCalculation('power', { a: 2, b: 3 });
      
      expect(result).toEqual({ result: 8 });
      expect(mock.history.post[0].url).toBe('http://mock-power:8005/power');
    });

    test('should route square root operation correctly', async () => {
      mock.onPost('http://mock-sqrt:8006/sqrt').reply(200, { result: 2 });
      
      const result = await routeCalculation('sqrt', { a: 4 });
      
      expect(result).toEqual({ result: 2 });
      expect(mock.history.post[0].url).toBe('http://mock-sqrt:8006/sqrt');
    });

    test('should route logarithm operations correctly', async () => {
      mock.onPost('http://mock-log:8007/log').reply(200, { result: 1 });
      
      const result = await routeCalculation('log', { a: 10 });
      
      expect(result).toEqual({ result: 1 });
      expect(mock.history.post[0].url).toBe('http://mock-log:8007/log');
    });

    test('should route trigonometry operations correctly', async () => {
      mock.onPost('http://mock-trig:8008/sin').reply(200, { result: 0 });
      
      const result = await routeCalculation('sin', { a: 0 });
      
      expect(result).toEqual({ result: 0 });
      expect(mock.history.post[0].url).toBe('http://mock-trig:8008/sin');
    });
  });

  describe('Special Operations', () => {
    test('should route factorial operations correctly', async () => {
      mock.onPost('http://mock-factorial:8010/factorial').reply(200, { result: 6 });
      
      const result = await routeCalculation('factorial', { a: 3 });
      
      expect(result).toEqual({ result: 6 });
      expect(mock.history.post[0].url).toBe('http://mock-factorial:8010/factorial');
    });

    test('should route matrix operations correctly', async () => {
      mock.onPost('http://mock-matrix:8014/add').reply(200, { 
        result: [[2, 4], [6, 8]] 
      });
      
      const result = await routeCalculation('matrix-add', { 
        a: [[1, 2], [3, 4]], 
        b: [[1, 2], [3, 4]] 
      });
      
      expect(result).toEqual({ result: [[2, 4], [6, 8]] });
      expect(mock.history.post[0].url).toBe('http://mock-matrix:8014/add');
    });

    test('should route bitwise operations correctly', async () => {
      mock.onPost('http://mock-bitwise:8016/and').reply(200, { result: 1 });
      
      const result = await routeCalculation('and', { a: 3, b: 1 });
      
      expect(result).toEqual({ result: 1 });
      expect(mock.history.post[0].url).toBe('http://mock-bitwise:8016/and');
    });

    test('should route complex number operations correctly', async () => {
      mock.onPost('http://mock-complex:8017/add').reply(200, { 
        result: { real: 2, imag: 4 } 
      });
      
      const result = await routeCalculation('complex-add', { 
        'real-a': 1, 'imag-a': 2, 
        'real-b': 1, 'imag-b': 2 
      });
      
      expect(result).toEqual({ result: { real: 2, imag: 4 } });
      expect(mock.history.post[0].url).toBe('http://mock-complex:8017/add');
    });
  });

  describe('Conversion Operations', () => {
    test('should route temperature conversion correctly', async () => {
      mock.onPost('http://mock-conversion:8012/temperature').reply(200, { result: 32 });
      
      const result = await routeCalculation('conversion', { 
        from: 'celsius', 
        to: 'fahrenheit', 
        value: 0 
      });
      
      expect(result).toEqual({ result: 32 });
      expect(mock.history.post[0].url).toBe('http://mock-conversion:8012/temperature');
    });

    test('should route length conversion correctly', async () => {
      mock.onPost('http://mock-conversion:8012/length').reply(200, { result: 100 });
      
      const result = await routeCalculation('conversion', { 
        from: 'meter', 
        to: 'centimeter', 
        value: 1 
      });
      
      expect(result).toEqual({ result: 100 });
      expect(mock.history.post[0].url).toBe('http://mock-conversion:8012/length');
    });

    test('should route weight conversion correctly', async () => {
      mock.onPost('http://mock-conversion:8012/weight').reply(200, { result: 1000 });
      
      const result = await routeCalculation('conversion', { 
        from: 'kilogram', 
        to: 'gram', 
        value: 1 
      });
      
      expect(result).toEqual({ result: 1000 });
      expect(mock.history.post[0].url).toBe('http://mock-conversion:8012/weight');
    });

    test('should throw error for invalid conversion units', async () => {
      await expect(routeCalculation('conversion', { 
        from: 'invalid', 
        to: 'unit', 
        value: 1 
      })).rejects.toThrow('Unsupported conversion units');
    });

    test('should throw error for missing conversion parameters', async () => {
      await expect(routeCalculation('conversion', { 
        from: 'kilogram', 
        to: 'gram'
        // Missing value
      })).rejects.toThrow('Missing conversion parameters');
    });
  });

  describe('Error Handling', () => {
    test('should throw error for unsupported operations', async () => {
      await expect(routeCalculation('unsupported', { a: 1 }))
        .rejects.toThrow('Unsupported operation');
    });

    test('should handle service errors', async () => {
      mock.onPost('http://mock-addition:8001/add').networkError();
      
      await expect(routeCalculation('add', { a: 1, b: 2 }))
        .rejects.toThrow();
    });
  });
});