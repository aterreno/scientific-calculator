import React, { useState } from 'react';
import axios from 'axios';
import './Calculator.css';
import Display from './Display';
import Keypad from './Keypad';
import ConversionModal from './ConversionModal';

const Calculator = () => {
  const [display, setDisplay] = useState('0');
  const [previousValue, setPreviousValue] = useState(null);
  const [operation, setOperation] = useState(null);
  const [waitingForOperand, setWaitingForOperand] = useState(false);
  const [memory, setMemory] = useState(0);

  const clearAll = () => {
    setDisplay('0');
    setPreviousValue(null);
    setOperation(null);
    setWaitingForOperand(false);
  };

  const clearDisplay = () => {
    setDisplay('0');
  };

  const toggleSign = () => {
    const value = parseFloat(display) * -1;
    setDisplay(String(value));
  };

  const inputPercent = () => {
    const value = parseFloat(display) / 100;
    setDisplay(String(value));
  };

  const inputDigit = (digit) => {
    if (waitingForOperand) {
      setDisplay(String(digit));
      setWaitingForOperand(false);
    } else {
      setDisplay(display === '0' ? String(digit) : display + digit);
    }
  };

  const inputDot = () => {
    if (waitingForOperand) {
      setDisplay('0.');
      setWaitingForOperand(false);
    } else if (display.indexOf('.') === -1) {
      setDisplay(display + '.');
    }
  };

  const performApiCalculation = async (operation, a, b = null) => {
    try {
      const payload = b !== null ? { operation, a, b } : { operation, a };
      const response = await axios.post('/api/calculate', payload);
      return response.data.result;
    } catch (error) {
      console.error('API calculation error:', error);
      return 'Error';
    }
  };

  const handleMemoryOperation = async (memoryOp) => {
    try {
      const payload = { operation: memoryOp };
      if (memoryOp !== 'memory-recall' && memoryOp !== 'memory-clear') {
        payload.a = parseFloat(display);
      }
      const response = await axios.post('/api/calculate', payload);
      setMemory(response.data.result);
      if (memoryOp === 'memory-recall') {
        setDisplay(String(response.data.result));
        setWaitingForOperand(true);
      }
    } catch (error) {
      console.error('Memory operation error:', error);
    }
  };

  const performOperation = async (nextOperation) => {
    const inputValue = parseFloat(display);

    if (previousValue === null) {
      setPreviousValue(inputValue);
    } else if (operation) {
      const operationMap = {
        add: 'add',
        subtract: 'subtract',
        multiply: 'multiply',
        divide: 'divide',
        power: 'power'
      };

      if (operationMap[operation]) {
        const result = await performApiCalculation(
          operationMap[operation],
          previousValue,
          inputValue
        );
        setDisplay(String(result));
        setPreviousValue(result);
      }
    }

    setWaitingForOperand(true);
    setOperation(nextOperation);
  };

  const handleEquals = async () => {
    const inputValue = parseFloat(display);

    if (previousValue !== null && operation) {
      const operationMap = {
        add: 'add',
        subtract: 'subtract',
        multiply: 'multiply',
        divide: 'divide',
        power: 'power'
      };

      if (operationMap[operation]) {
        const result = await performApiCalculation(
          operationMap[operation],
          previousValue,
          inputValue
        );
        setDisplay(String(result));
        setPreviousValue(null);
        setOperation(null);
        setWaitingForOperand(true);
      }
    }
  };

  const handleSpecialOperation = async (op) => {
    const inputValue = parseFloat(display);
    let result;

    switch (op) {
      case 'sqrt':
        result = await performApiCalculation('sqrt', inputValue);
        break;
      case 'square':
        result = await performApiCalculation('square', inputValue);
        break;
      case 'sin':
      case 'cos':
      case 'tan':
      case 'log':
      case 'ln':
        result = await performApiCalculation(op, inputValue);
        break;
      case 'factorial':
        result = await performApiCalculation('factorial', inputValue);
        break;
      case 'permutation':
      case 'combination':
        const secondInput = parseFloat(prompt(`Enter r value for ${op}:`));
        if (isNaN(secondInput)) return;
        result = await performApiCalculation(op, inputValue, secondInput);
        break;
      case 'convert':
        setShowConversionModal(true);
        return; // Exit early to prevent display update
        break;
      default:
        return;
    }

    setDisplay(String(result));
    setWaitingForOperand(true);
  };
  
  // Complex number operations - for simplicity, we'll use a prompt for the second number
  const handleComplexOperation = async (op) => {
    const realA = parseFloat(display);
    const imagA = parseFloat(prompt('Enter imaginary part of first number:') || '0');
    
    let realB, imagB, result;
    
    // For operations that need two complex numbers
    if (['complex-add', 'complex-subtract', 'complex-multiply', 'complex-divide'].includes(op)) {
      realB = parseFloat(prompt('Enter real part of second number:') || '0');
      imagB = parseFloat(prompt('Enter imaginary part of second number:') || '0');
      
      result = await performApiCalculation(op, {
        'real-a': realA,
        'imag-a': imagA,
        'real-b': realB,
        'imag-b': imagB
      });
    } else {
      // For unary operations like magnitude and conjugate
      result = await performApiCalculation(op, {
        'real': realA,
        'imag': imagA
      });
    }
    
    if (typeof result === 'object' && result.real !== undefined) {
      // Display complex result
      setDisplay(`${result.real.toFixed(2)} + ${result.imag.toFixed(2)}i`);
    } else {
      // Display scalar result
      setDisplay(String(result));
    }
    setWaitingForOperand(true);
  };

  // Advanced operations menu
  const [showAdvancedMenu, setShowAdvancedMenu] = useState(false);
  
  // Conversion modal state
  const [showConversionModal, setShowConversionModal] = useState(false);
  
  const handleAdvancedOperation = (type) => {
    setShowAdvancedMenu(false);
    
    switch (type) {
      case 'complex':
        const complexOp = prompt('Select complex operation: add, subtract, multiply, divide, magnitude, conjugate');
        if (complexOp) {
          handleComplexOperation(`complex-${complexOp}`);
        }
        break;
      case 'matrix':
        const matrixOp = prompt('Select matrix operation: add, multiply, determinant, inverse');
        if (matrixOp) {
          alert(`Matrix operation ${matrixOp} would be displayed here`);
        }
        break;
      case 'bitwise':
        const bitwiseOp = prompt('Select bitwise operation: and, or, xor, not, left-shift, right-shift');
        if (bitwiseOp) {
          alert(`Bitwise operation ${bitwiseOp} would be displayed here`);
        }
        break;
      case 'conversion':
        setShowConversionModal(true);
        break;
      default:
        break;
    }
  };

  // Handle conversion result
  const handleConversionResult = (result) => {
    setDisplay(String(result));
    setWaitingForOperand(true);
    setShowConversionModal(false);
  };

  return (
    <div className="calculator">
      <Display value={display} />
      <div className="advanced-menu-toggle">
        <button onClick={() => setShowAdvancedMenu(!showAdvancedMenu)}>
          {showAdvancedMenu ? 'Hide Advanced' : 'Show Advanced'}
        </button>
      </div>
      
      {showAdvancedMenu && (
        <div className="advanced-menu">
          <button onClick={() => handleAdvancedOperation('complex')}>Complex Numbers</button>
          <button onClick={() => handleAdvancedOperation('matrix')}>Matrix</button>
          <button onClick={() => handleAdvancedOperation('bitwise')}>Bitwise</button>
          <button onClick={() => handleAdvancedOperation('conversion')}>Conversion</button>
        </div>
      )}
      
      <Keypad
        onClearAll={clearAll}
        onClearDisplay={clearDisplay}
        onToggleSign={toggleSign}
        onPercent={inputPercent}
        onDigit={inputDigit}
        onDot={inputDot}
        onOperation={performOperation}
        onEquals={handleEquals}
        onSpecialOperation={handleSpecialOperation}
        onMemoryOperation={handleMemoryOperation}
      />

      {/* Conversion Modal */}
      <ConversionModal 
        isOpen={showConversionModal}
        onClose={() => setShowConversionModal(false)}
        onConversionResult={handleConversionResult}
      />
    </div>
  );
};

export default Calculator;