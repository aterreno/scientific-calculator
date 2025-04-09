export class Converter {
  // Temperature conversion factors
  private static readonly temperatureUnits = ['celsius', 'fahrenheit', 'kelvin'];
  
  // Length conversion factors (to meters)
  private static readonly lengthFactors: Record<string, number> = {
    'meter': 1,
    'centimeter': 0.01,
    'millimeter': 0.001,
    'kilometer': 1000,
    'inch': 0.0254,
    'foot': 0.3048,
    'yard': 0.9144,
    'mile': 1609.34
  };
  
  // Weight conversion factors (to kilograms)
  private static readonly weightFactors: Record<string, number> = {
    'kilogram': 1,
    'gram': 0.001,
    'milligram': 0.000001,
    'pound': 0.453592,
    'ounce': 0.0283495,
    'ton': 1000
  };
  
  /**
   * Convert temperature between Celsius, Fahrenheit, and Kelvin
   */
  public static convertTemperature(value: number, from: string, to: string): number {
    from = from.toLowerCase();
    to = to.toLowerCase();
    
    if (!this.temperatureUnits.includes(from) || !this.temperatureUnits.includes(to)) {
      throw new Error(`Unsupported temperature units. Supported: ${this.temperatureUnits.join(', ')}`);
    }
    
    // Convert to Celsius as intermediate step
    let celsius: number;
    
    switch (from) {
      case 'celsius':
        celsius = value;
        break;
      case 'fahrenheit':
        celsius = (value - 32) * (5/9);
        break;
      case 'kelvin':
        celsius = value - 273.15;
        break;
      default:
        throw new Error(`Unknown temperature unit: ${from}`);
    }
    
    // Convert from Celsius to target unit
    switch (to) {
      case 'celsius':
        return celsius;
      case 'fahrenheit':
        return (celsius * (9/5)) + 32;
      case 'kelvin':
        return celsius + 273.15;
      default:
        throw new Error(`Unknown temperature unit: ${to}`);
    }
  }
  
  /**
   * Convert length between units
   */
  public static convertLength(value: number, from: string, to: string): number {
    from = from.toLowerCase();
    to = to.toLowerCase();
    
    if (!(from in this.lengthFactors) || !(to in this.lengthFactors)) {
      throw new Error(`Unsupported length units. Supported: ${Object.keys(this.lengthFactors).join(', ')}`);
    }
    
    // Convert to meters, then to target unit
    const meters = value * this.lengthFactors[from];
    return meters / this.lengthFactors[to];
  }
  
  /**
   * Convert weight between units
   */
  public static convertWeight(value: number, from: string, to: string): number {
    from = from.toLowerCase();
    to = to.toLowerCase();
    
    if (!(from in this.weightFactors) || !(to in this.weightFactors)) {
      throw new Error(`Unsupported weight units. Supported: ${Object.keys(this.weightFactors).join(', ')}`);
    }
    
    // Convert to kilograms, then to target unit
    const kilograms = value * this.weightFactors[from];
    return kilograms / this.weightFactors[to];
  }
}