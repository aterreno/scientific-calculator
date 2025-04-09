import React from 'react';
import './App.css';
import Calculator from './components/Calculator';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>Microservice Scientific Calculator</h1>
      </header>
      <main>
        <Calculator />
      </main>
      <footer className="App-footer">
        <p>Powered by 10 microservices written in different languages</p>
      </footer>
    </div>
  );
}

export default App;