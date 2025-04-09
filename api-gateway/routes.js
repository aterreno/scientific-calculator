const axios = require('axios');

// Service URLs
const SERVICES = {
  addition: 'http://addition-service:8001',
  subtraction: 'http://subtraction-service:8002',
  multiplication: 'http://multiplication-service:8003',
  division: 'http://division-service:8004',
  power: 'http://power-service:8005',
  squareRoot: 'http://square-root-service:8006',
  logarithm: 'http://log-service:8007',
  trigonometry: 'http://trig-service:8008',
  memory: 'http://memory-service:8009',
  factorial: 'http://factorial-service:8010',
  conversion: 'http://conversion-service:8012',
  matrix: 'http://matrix-service:8014',
  bitwise: 'http://bitwise-service:8016',
  complex: 'http://complex-service:8017'
};

// For testing purposes - allows injection of custom services
function setServices(services) {
  Object.keys(services).forEach(key => {
    SERVICES[key] = services[key];
  });
}

// For testing purposes - reset to defaults or get current services
function getServices() {
  return {...SERVICES};
}

// Core function to route calculation requests
async function routeCalculation(operation, params) {
  let serviceUrl;
  let endpoint;
  
  switch (operation) {
    case 'add':
      serviceUrl = SERVICES.addition;
      endpoint = '/add';
      break;
    case 'subtract':
      serviceUrl = SERVICES.subtraction;
      endpoint = '/subtract';
      break;
    case 'multiply':
      serviceUrl = SERVICES.multiplication;
      endpoint = '/multiply';
      break;
    case 'divide':
      serviceUrl = SERVICES.division;
      endpoint = '/divide';
      break;
    case 'power':
    case 'square':
    case 'cube':
      serviceUrl = SERVICES.power;
      endpoint = `/${operation}`;
      break;
    case 'sqrt':
      serviceUrl = SERVICES.squareRoot;
      endpoint = '/sqrt';
      break;
    case 'log':
    case 'ln':
    case 'log10':
      serviceUrl = SERVICES.logarithm;
      endpoint = `/${operation}`;
      break;
    case 'sin':
    case 'cos':
    case 'tan':
    case 'asin':
    case 'acos':
    case 'atan':
      serviceUrl = SERVICES.trigonometry;
      endpoint = `/${operation}`;
      break;
    case 'memory-add':
    case 'memory-subtract':
    case 'memory-recall':
    case 'memory-clear':
      serviceUrl = SERVICES.memory;
      endpoint = `/${operation}`;
      break;
    case 'factorial':
    case 'permutation':
    case 'combination':
      serviceUrl = SERVICES.factorial;
      endpoint = `/${operation}`;
      break;
    case 'conversion':
      serviceUrl = SERVICES.conversion;
      // For universal conversion handling
      if (params.from && params.to && params.value !== undefined) {
        // Determine conversion type based on units
        const tempUnits = ['celsius', 'fahrenheit', 'kelvin'];
        const lengthUnits = ['meter', 'centimeter', 'millimeter', 'kilometer', 'inch', 'foot', 'yard', 'mile'];
        const weightUnits = ['kilogram', 'gram', 'milligram', 'pound', 'ounce', 'ton'];
        
        const fromLower = params.from.toLowerCase();
        const toLower = params.to.toLowerCase();
        
        if (tempUnits.includes(fromLower) && tempUnits.includes(toLower)) {
          endpoint = '/temperature';
        } else if (lengthUnits.includes(fromLower) && lengthUnits.includes(toLower)) {
          endpoint = '/length';
        } else if (weightUnits.includes(fromLower) && weightUnits.includes(toLower)) {
          endpoint = '/weight';
        } else {
          throw new Error(`Unsupported conversion units: ${params.from} to ${params.to}`);
        }
      } else {
        throw new Error('Missing conversion parameters. Required: from, to, value');
      }
      break;
    case 'matrix-add':
      serviceUrl = SERVICES.matrix;
      endpoint = '/add';
      break;
    case 'matrix-multiply':
      serviceUrl = SERVICES.matrix;
      endpoint = '/multiply';
      break;
    case 'matrix-determinant':
      serviceUrl = SERVICES.matrix;
      endpoint = '/determinant';
      break;
    case 'matrix-inverse':
      serviceUrl = SERVICES.matrix;
      endpoint = '/inverse';
      break;
    case 'and':
    case 'or':
    case 'xor':
    case 'not':
    case 'left-shift':
    case 'right-shift':
      serviceUrl = SERVICES.bitwise;
      endpoint = `/${operation}`;
      break;
    case 'complex-add':
    case 'complex-subtract':
    case 'complex-multiply':
    case 'complex-divide':
    case 'complex-magnitude':
    case 'complex-conjugate':
      serviceUrl = SERVICES.complex;
      endpoint = `/${operation.replace('complex-', '')}`;
      break;
    default:
      throw new Error(`Unsupported operation: ${operation}`);
  }
  
  // Make the request to the appropriate service
  const response = await axios.post(`${serviceUrl}${endpoint}`, params);
  return response.data;
}

module.exports = {
  routeCalculation,
  getServices,
  setServices
};