import React, { useState } from 'react';
import axios from 'axios';
import './Keypad.css'; // Using the styles we added to Keypad.css

const ConversionModal = ({ isOpen, onClose, onConversionResult }) => {
  const [conversionType, setConversionType] = useState('temperature');
  const [value, setValue] = useState('');
  const [fromUnit, setFromUnit] = useState('celsius');
  const [toUnit, setToUnit] = useState('fahrenheit');
  const [result, setResult] = useState(null);
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  // Define available units for each conversion type
  const conversionUnits = {
    temperature: ['celsius', 'fahrenheit', 'kelvin'],
    length: ['meter', 'centimeter', 'millimeter', 'kilometer', 'inch', 'foot', 'yard', 'mile'],
    weight: ['kilogram', 'gram', 'milligram', 'pound', 'ounce', 'ton'],
  };

  // Reset form when conversion type changes
  const handleConversionTypeChange = (type) => {
    setConversionType(type);
    setFromUnit(conversionUnits[type][0]);
    setToUnit(conversionUnits[type][1]);
    setResult(null);
    setError('');
  };

  const handleConvert = async (e) => {
    e.preventDefault();
    
    if (!value || isNaN(parseFloat(value))) {
      setError('Please enter a valid number');
      return;
    }
    
    setIsLoading(true);
    setError('');
    
    try {
      const response = await axios.post('/api/calculate', {
        operation: 'conversion',
        from: fromUnit,
        to: toUnit,
        value: parseFloat(value)
      });
      
      setResult(response.data.result);
      
      // Also send result back to calculator for display
      if (onConversionResult) {
        onConversionResult(response.data.result);
      }
    } catch (error) {
      console.error('Conversion error:', error);
      setError(error.response?.data?.error || 'An error occurred during conversion');
    } finally {
      setIsLoading(false);
    }
  };

  if (!isOpen) return null;

  return (
    <div className="conversion-modal">
      <div className="conversion-content">
        <div className="conversion-header">
          <h3>Unit Conversion</h3>
          <button className="conversion-close" onClick={onClose}>&times;</button>
        </div>
        
        <form className="conversion-form" onSubmit={handleConvert}>
          <select 
            value={conversionType} 
            onChange={(e) => handleConversionTypeChange(e.target.value)}
          >
            <option value="temperature">Temperature</option>
            <option value="length">Length</option>
            <option value="weight">Weight</option>
          </select>
          
          <input
            type="number"
            placeholder="Enter value"
            value={value}
            onChange={(e) => setValue(e.target.value)}
            required
          />
          
          <select 
            value={fromUnit} 
            onChange={(e) => setFromUnit(e.target.value)}
          >
            {conversionUnits[conversionType].map(unit => (
              <option key={`from-${unit}`} value={unit}>
                {unit.charAt(0).toUpperCase() + unit.slice(1)}
              </option>
            ))}
          </select>
          
          <select 
            value={toUnit} 
            onChange={(e) => setToUnit(e.target.value)}
          >
            {conversionUnits[conversionType].map(unit => (
              <option key={`to-${unit}`} value={unit}>
                {unit.charAt(0).toUpperCase() + unit.slice(1)}
              </option>
            ))}
          </select>
          
          <button type="submit" disabled={isLoading}>
            {isLoading ? 'Converting...' : 'Convert'}
          </button>
          
          {error && <p style={{ color: 'red' }}>{error}</p>}
          
          {result !== null && (
            <div className="conversion-result">
              <p>
                {value} {fromUnit} = <strong>{result}</strong> {toUnit}
              </p>
            </div>
          )}
        </form>
      </div>
    </div>
  );
};

export default ConversionModal;