const axios = require('axios');

// Helper function to get service URL from environment or default value
function getServiceUrl(serviceName, defaultPort) {
  // Convert "service-name" to "SERVICE_NAME" (removing the "-service" suffix first)
  const baseName = serviceName.replace(/-service$/, '');
  const envVarName = `${baseName.toUpperCase().replace(/-/g, '_')}_SERVICE_URL`;
  
  const envUrl = process.env[envVarName];
  const defaultUrl = `http://${serviceName}:${defaultPort}`;
  
  // Log the environment variable lookup for debugging
  console.log(`Looking for service ${serviceName}:`);
  console.log(`  - Environment variable: ${envVarName}`);
  console.log(`  - Environment value: ${envUrl || 'not set'}`);
  console.log(`  - Using URL: ${envUrl || defaultUrl}`);
  
  return envUrl || defaultUrl;
}

// Service configuration - maps service keys to their service names and ports
const SERVICE_CONFIG = {
  addition: { name: 'addition-service', port: 8001 },
  subtraction: { name: 'subtraction-service', port: 8002 },
  multiplication: { name: 'multiplication-service', port: 8003 },
  division: { name: 'division-service', port: 8004 },
  power: { name: 'power-service', port: 8005 },
  squareRoot: { name: 'square-root-service', port: 8006 },
  logarithm: { name: 'log-service', port: 8007 },
  trigonometry: { name: 'trig-service', port: 8008 },
  memory: { name: 'memory-service', port: 8009 },
  factorial: { name: 'factorial-service', port: 8010 },
  conversion: { name: 'conversion-service', port: 8012 },
  matrix: { name: 'matrix-service', port: 8014 },
  bitwise: { name: 'bitwise-service', port: 8016 },
  complex: { name: 'complex-service', port: 8017 }
};

// Function to dynamically get all service URLs
function getServiceUrls() {
  const urls = {};
  
  // Get URL for each service using environment variables or defaults
  Object.entries(SERVICE_CONFIG).forEach(([key, config]) => {
    urls[key] = getServiceUrl(config.name, config.port);
  });
  
  return urls;
}

// Get service URLs - this will be dynamically evaluated each time it's called
function getServices() {
  return getServiceUrls();
}

// For testing purposes - allows injection of custom services
// Now uses a module-level variable that can be overridden
let _customServiceUrls = null;

function setServices(services) {
  _customServiceUrls = services;
}

// For testing purposes or to get current services
// Returns customized services if set, otherwise dynamically gets the services
function getServices() {
  if (_customServiceUrls) {
    return {..._customServiceUrls};
  }
  return getServiceUrls();
}

// Core function to route calculation requests
async function routeCalculation(operation, params) {
  // Get the latest service URLs (ensures environment variables are used)
  const SERVICES = getServiceUrls();
  
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