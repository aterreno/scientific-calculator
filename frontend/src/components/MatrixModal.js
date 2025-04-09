import React, { useState } from 'react';
import axios from 'axios';
import './Keypad.css'; // Reusing the modal styles from Keypad.css

const MatrixModal = ({ isOpen, onClose, onMatrixResult }) => {
  const [operation, setOperation] = useState('add');
  const [matrixA, setMatrixA] = useState([
    [1, 2],
    [3, 4]
  ]);
  const [matrixB, setMatrixB] = useState([
    [5, 6],
    [7, 8]
  ]);
  const [result, setResult] = useState(null);
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [rowsA, setRowsA] = useState(2);
  const [colsA, setColsA] = useState(2);
  const [rowsB, setRowsB] = useState(2);
  const [colsB, setColsB] = useState(2);

  // Reset matrices when dimensions change
  const handleMatrixDimensionsChange = (matrix, rows, cols) => {
    let newMatrix = [];
    for (let i = 0; i < rows; i++) {
      newMatrix[i] = [];
      for (let j = 0; j < cols; j++) {
        // Preserve existing values when possible
        newMatrix[i][j] = matrix[i] && matrix[i][j] !== undefined ? matrix[i][j] : 0;
      }
    }
    return newMatrix;
  };

  const handleRowsAChange = (e) => {
    const newRows = parseInt(e.target.value);
    setRowsA(newRows);
    setMatrixA(handleMatrixDimensionsChange(matrixA, newRows, colsA));
  };

  const handleColsAChange = (e) => {
    const newCols = parseInt(e.target.value);
    setColsA(newCols);
    setMatrixA(handleMatrixDimensionsChange(matrixA, rowsA, newCols));
    
    // If multiplication is selected, update the rows of matrix B
    if (operation === 'multiply') {
      setRowsB(newCols);
      setMatrixB(handleMatrixDimensionsChange(matrixB, newCols, colsB));
    }
  };

  const handleRowsBChange = (e) => {
    const newRows = parseInt(e.target.value);
    setRowsB(newRows);
    setMatrixB(handleMatrixDimensionsChange(matrixB, newRows, colsB));
  };

  const handleColsBChange = (e) => {
    const newCols = parseInt(e.target.value);
    setColsB(newCols);
    setMatrixB(handleMatrixDimensionsChange(matrixB, rowsB, newCols));
  };

  const handleOperationChange = (e) => {
    const newOperation = e.target.value;
    setOperation(newOperation);
    setResult(null);
    setError('');
    
    // For multiplication, ensure rowsB = colsA
    if (newOperation === 'multiply') {
      setRowsB(colsA);
      setMatrixB(handleMatrixDimensionsChange(matrixB, colsA, colsB));
    }
    
    // For determinant and inverse, ensure matrixA is square
    if (newOperation === 'determinant' || newOperation === 'inverse') {
      if (rowsA !== colsA) {
        // Make matrix A square
        const size = Math.max(rowsA, colsA);
        setRowsA(size);
        setColsA(size);
        setMatrixA(handleMatrixDimensionsChange(matrixA, size, size));
      }
    }
  };

  const handleMatrixAChange = (rowIndex, colIndex, value) => {
    const newValue = value === '' ? 0 : Number(value);
    const newMatrix = [...matrixA];
    newMatrix[rowIndex][colIndex] = newValue;
    setMatrixA(newMatrix);
  };

  const handleMatrixBChange = (rowIndex, colIndex, value) => {
    const newValue = value === '' ? 0 : Number(value);
    const newMatrix = [...matrixB];
    newMatrix[rowIndex][colIndex] = newValue;
    setMatrixB(newMatrix);
  };

  const handleCalculate = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    setError('');
    
    try {
      // Check matrix dimensions for operation
      if (operation === 'add' && (rowsA !== rowsB || colsA !== colsB)) {
        throw new Error('For addition, matrices must have the same dimensions');
      }
      
      if (operation === 'multiply' && colsA !== rowsB) {
        throw new Error('For multiplication, the number of columns in the first matrix must equal the number of rows in the second matrix');
      }
      
      if ((operation === 'determinant' || operation === 'inverse') && rowsA !== colsA) {
        throw new Error('For determinant and inverse operations, the matrix must be square');
      }
      
      let payload = {
        operation: `matrix-${operation}`
      };
      
      // Add matrices to payload based on operation
      if (operation === 'add' || operation === 'multiply') {
        payload = {
          ...payload,
          a: matrixA,
          b: matrixB
        };
      } else { // determinant or inverse
        payload = {
          ...payload,
          a: matrixA
        };
      }
      
      const response = await axios.post('/api/calculate', payload);
      
      setResult(response.data.result);
      
      // Also send result back to calculator for display if it's a scalar
      if (onMatrixResult && (operation === 'determinant' || typeof response.data.result === 'number')) {
        onMatrixResult(response.data.result);
        onClose();
      }
    } catch (error) {
      console.error('Matrix operation error:', error);
      setError(error.message || error.response?.data?.error || 'An error occurred during calculation');
    } finally {
      setIsLoading(false);
    }
  };

  if (!isOpen) return null;

  // Determine if we need to show matrix B input
  const showMatrixB = operation === 'add' || operation === 'multiply';
  
  // Determine if matrix A needs to be square
  const squareMatrixA = operation === 'determinant' || operation === 'inverse';

  return (
    <div className="conversion-modal matrix-modal">
      <div className="conversion-content">
        <div className="conversion-header">
          <h3>Matrix Operations</h3>
          <button className="conversion-close" onClick={onClose}>&times;</button>
        </div>
        
        <form className="conversion-form" onSubmit={handleCalculate}>
          <select 
            value={operation} 
            onChange={handleOperationChange}
          >
            <option value="add">Addition (A + B)</option>
            <option value="multiply">Multiplication (A × B)</option>
            <option value="determinant">Determinant (|A|)</option>
            <option value="inverse">Inverse (A⁻¹)</option>
          </select>
          
          <div className="matrix-inputs">
            <div className="matrix-input-container">
              <h4>Matrix A {squareMatrixA && "(Must be square)"}</h4>
              
              <div className="matrix-dimensions">
                <label>
                  Rows:
                  <input 
                    type="number" 
                    min="1" 
                    max="5" 
                    value={rowsA}
                    onChange={handleRowsAChange}
                    disabled={squareMatrixA && colsA !== rowsA}
                  />
                </label>
                <label>
                  Columns:
                  <input 
                    type="number" 
                    min="1" 
                    max="5" 
                    value={colsA}
                    onChange={handleColsAChange}
                    disabled={squareMatrixA && colsA !== rowsA}
                  />
                </label>
              </div>
              
              <div className="matrix-grid">
                {Array.from({ length: rowsA }).map((_, rowIndex) => (
                  <div key={`row-a-${rowIndex}`} className="matrix-row">
                    {Array.from({ length: colsA }).map((_, colIndex) => (
                      <input
                        key={`cell-a-${rowIndex}-${colIndex}`}
                        type="number"
                        value={matrixA[rowIndex][colIndex]}
                        onChange={(e) => handleMatrixAChange(rowIndex, colIndex, e.target.value)}
                      />
                    ))}
                  </div>
                ))}
              </div>
            </div>
            
            {showMatrixB && (
              <div className="matrix-input-container">
                <h4>Matrix B</h4>
                
                <div className="matrix-dimensions">
                  <label>
                    Rows:
                    <input 
                      type="number" 
                      min="1" 
                      max="5" 
                      value={rowsB}
                      onChange={handleRowsBChange}
                      disabled={operation === 'multiply'}
                    />
                  </label>
                  <label>
                    Columns:
                    <input 
                      type="number" 
                      min="1" 
                      max="5" 
                      value={colsB}
                      onChange={handleColsBChange}
                    />
                  </label>
                </div>
                
                <div className="matrix-grid">
                  {Array.from({ length: rowsB }).map((_, rowIndex) => (
                    <div key={`row-b-${rowIndex}`} className="matrix-row">
                      {Array.from({ length: colsB }).map((_, colIndex) => (
                        <input
                          key={`cell-b-${rowIndex}-${colIndex}`}
                          type="number"
                          value={matrixB[rowIndex][colIndex]}
                          onChange={(e) => handleMatrixBChange(rowIndex, colIndex, e.target.value)}
                        />
                      ))}
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
          
          <button type="submit" disabled={isLoading}>
            {isLoading ? 'Calculating...' : 'Calculate'}
          </button>
          
          {error && <p style={{ color: 'red' }}>{error}</p>}
          
          {result !== null && (
            <div className="conversion-result matrix-result">
              <h4>Result:</h4>
              {typeof result === 'number' ? (
                <p>{result}</p>
              ) : (
                <div className="matrix-grid result-grid">
                  {result.map((row, rowIndex) => (
                    <div key={`row-result-${rowIndex}`} className="matrix-row">
                      {row.map((cell, colIndex) => (
                        <div key={`cell-result-${rowIndex}-${colIndex}`} className="matrix-cell">
                          {typeof cell === 'number' ? cell.toFixed(2) : cell}
                        </div>
                      ))}
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}
        </form>
      </div>
    </div>
  );
};

export default MatrixModal;