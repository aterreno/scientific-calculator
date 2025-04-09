import React from 'react';
import './Keypad.css';

const Keypad = ({
  onClearAll,
  onClearDisplay,
  onToggleSign,
  onPercent,
  onDigit,
  onDot,
  onOperation,
  onEquals,
  onSpecialOperation,
  onMemoryOperation
}) => {
  return (
    <div className="calculator-keypad">
      <div className="input-keys">
        {/* Scientific Functions */}
        <div className="scientific-function-keys">
          <button className="key-sin" onClick={() => onSpecialOperation('sin')}>sin</button>
          <button className="key-cos" onClick={() => onSpecialOperation('cos')}>cos</button>
          <button className="key-tan" onClick={() => onSpecialOperation('tan')}>tan</button>
          <button className="key-ln" onClick={() => onSpecialOperation('ln')}>ln</button>
          <button className="key-log" onClick={() => onSpecialOperation('log')}>log</button>
          <button className="key-sqrt" onClick={() => onSpecialOperation('sqrt')}>√</button>
          <button className="key-square" onClick={() => onSpecialOperation('square')}>x²</button>
          <button className="key-power" onClick={() => onOperation('power')}>xʸ</button>
        </div>
        
        {/* Factorial Functions */}
        <div className="factorial-keys">
          <button className="key-factorial" onClick={() => onSpecialOperation('factorial')}>n!</button>
          <button className="key-perm" onClick={() => onSpecialOperation('permutation')}>nPr</button>
          <button className="key-comb" onClick={() => onSpecialOperation('combination')}>nCr</button>
          <button className="key-convert" onClick={() => onSpecialOperation('convert')}>Conv</button>
          <button className="key-matrix" onClick={() => onSpecialOperation('matrix')}>Matrix</button>
        </div>
        
        {/* Memory Functions */}
        <div className="memory-keys">
          <button className="key-memory-clear" onClick={() => onMemoryOperation('memory-clear')}>MC</button>
          <button className="key-memory-recall" onClick={() => onMemoryOperation('memory-recall')}>MR</button>
          <button className="key-memory-add" onClick={() => onMemoryOperation('memory-add')}>M+</button>
          <button className="key-memory-subtract" onClick={() => onMemoryOperation('memory-subtract')}>M-</button>
        </div>

        {/* Function Keys */}
        <div className="function-keys">
          <button className="key-clear-all" onClick={onClearAll}>AC</button>
          <button className="key-clear" onClick={onClearDisplay}>C</button>
          <button className="key-sign" onClick={onToggleSign}>±</button>
          <button className="key-percent" onClick={onPercent}>%</button>
        </div>

        {/* Digit Keys */}
        <div className="digit-keys">
          <button className="key-0" onClick={() => onDigit(0)}>0</button>
          <button className="key-dot" onClick={onDot}>.</button>
          <button className="key-1" onClick={() => onDigit(1)}>1</button>
          <button className="key-2" onClick={() => onDigit(2)}>2</button>
          <button className="key-3" onClick={() => onDigit(3)}>3</button>
          <button className="key-4" onClick={() => onDigit(4)}>4</button>
          <button className="key-5" onClick={() => onDigit(5)}>5</button>
          <button className="key-6" onClick={() => onDigit(6)}>6</button>
          <button className="key-7" onClick={() => onDigit(7)}>7</button>
          <button className="key-8" onClick={() => onDigit(8)}>8</button>
          <button className="key-9" onClick={() => onDigit(9)}>9</button>
        </div>
      </div>

      {/* Operator Keys */}
      <div className="operator-keys">
        <button className="key-divide" onClick={() => onOperation('divide')}>÷</button>
        <button className="key-multiply" onClick={() => onOperation('multiply')}>×</button>
        <button className="key-subtract" onClick={() => onOperation('subtract')}>−</button>
        <button className="key-add" onClick={() => onOperation('add')}>+</button>
        <button className="key-equals" onClick={onEquals}>=</button>
      </div>
    </div>
  );
};

export default Keypad;