import React, { useState } from 'react';
import axios from 'axios';
import './Keypad.css'; // Reusing the modal styles

const BitwiseModal = ({ isOpen, onClose, onBitwiseResult }) => {
  const [operation, setOperation] = useState('and');
  const [valueA, setValueA] = useState(0);
  const [valueB, setValueB] = useState(0);
  const [bits, setBits] = useState(1);
  const [result, setResult] = useState(null);
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [displayBase, setDisplayBase] = useState('decimal');

  // Format a number according to selected base
  const formatNumber = (num) => {
    switch (displayBase) {
      case 'binary':
        return '0b' + (num >>> 0).toString(2);
      case 'octal':
        return '0o' + (num >>> 0).toString(8);
      case 'hexadecimal':
        return '0x' + (num >>> 0).toString(16).toUpperCase();
      default:
        return num.toString();
    }
  };

  // Parse input from any base
  const parseInput = (value) => {
    if (typeof value === 'string') {
      if (value.startsWith('0b')) return parseInt(value.substring(2), 2);
      if (value.startsWith('0o')) return parseInt(value.substring(2), 8);
      if (value.startsWith('0x')) return parseInt(value.substring(2), 16);
    }
    return parseInt(value, 10);
  };

  const handleValueAChange = (e) => {
    setValueA(e.target.value);
  };

  const handleValueBChange = (e) => {
    setValueB(e.target.value);
  };

  const handleBitsChange = (e) => {
    setBits(e.target.value);
  };

  const handleOperationChange = (e) => {
    setOperation(e.target.value);
    setResult(null);
    setError('');
  };

  const handleDisplayBaseChange = (e) => {
    setDisplayBase(e.target.value);
  };

  const handleCalculate = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    setError('');
    
    try {
      let payload = {};
      let parsedA = parseInput(valueA);
      
      // Validate inputs
      if (isNaN(parsedA)) {
        throw new Error('First operand must be a valid number');
      }
      
      if (operation === 'not') {
        payload = {
          operation: operation,
          a: parsedA
        };
      } else if (operation === 'left-shift' || operation === 'right-shift') {
        const parsedBits = parseInput(bits);
        if (isNaN(parsedBits) || parsedBits < 0) {
          throw new Error('Bits must be a non-negative number');
        }
        
        payload = {
          operation: operation,
          a: parsedA,
          bits: parsedBits
        };
      } else {
        // AND, OR, XOR operations
        const parsedB = parseInput(valueB);
        if (isNaN(parsedB)) {
          throw new Error('Second operand must be a valid number');
        }
        
        payload = {
          operation: operation,
          a: parsedA,
          b: parsedB
        };
      }
      
      const response = await axios.post('/api/calculate', payload);
      
      setResult(response.data.result);
      
      // Also send result back to calculator for display
      if (onBitwiseResult) {
        onBitwiseResult(response.data.result);
      }
    } catch (error) {
      console.error('Bitwise operation error:', error);
      setError(error.message || error.response?.data?.error || 'An error occurred during calculation');
    } finally {
      setIsLoading(false);
    }
  };

  if (!isOpen) return null;

  return (
    <div className="conversion-modal bitwise-modal">
      <div className="conversion-content">
        <div className="conversion-header">
          <h3>Bitwise Operations</h3>
          <button className="conversion-close" onClick={onClose}>&times;</button>
        </div>
        
        <form className="conversion-form" onSubmit={handleCalculate}>
          {/* Operation selection */}
          <div className="operation-selection">
            <label>
              Operation:
              <select value={operation} onChange={handleOperationChange}>
                <option value="and">AND (&amp;)</option>
                <option value="or">OR (|)</option>
                <option value="xor">XOR (^)</option>
                <option value="not">NOT (~)</option>
                <option value="left-shift">Left Shift (&lt;&lt;)</option>
                <option value="right-shift">Right Shift (&gt;&gt;)</option>
              </select>
            </label>
          </div>
          
          {/* Display base selection */}
          <div className="display-base-selection">
            <label>
              Display Base:
              <select value={displayBase} onChange={handleDisplayBaseChange}>
                <option value="decimal">Decimal</option>
                <option value="binary">Binary</option>
                <option value="octal">Octal</option>
                <option value="hexadecimal">Hexadecimal</option>
              </select>
            </label>
          </div>
          
          {/* Input A */}
          <div className="input-field">
            <label>
              Operand A:
              <input 
                type="text" 
                value={valueA}
                onChange={handleValueAChange}
                placeholder="Enter first operand"
              />
            </label>
            <small>
              You can enter values in decimal, binary (0b...), octal (0o...), or hexadecimal (0x...)
            </small>
          </div>
          
          {/* Input B or Bits (depending on operation) */}
          {operation !== 'not' && (
            <div className="input-field">
              <label>
                {operation === 'left-shift' || operation === 'right-shift' ? 'Shift by bits:' : 'Operand B:'}
                <input 
                  type="text" 
                  value={operation === 'left-shift' || operation === 'right-shift' ? bits : valueB}
                  onChange={operation === 'left-shift' || operation === 'right-shift' ? handleBitsChange : handleValueBChange}
                  placeholder={operation === 'left-shift' || operation === 'right-shift' ? "Enter bits to shift" : "Enter second operand"}
                />
              </label>
            </div>
          )}
          
          <button type="submit" disabled={isLoading}>
            {isLoading ? 'Calculating...' : 'Calculate'}
          </button>
          
          {error && <p className="error-message">{error}</p>}          
        </form>
      </div>
    </div>
  );
};

export default BitwiseModal;