import React from 'react';
import './App.css';
import Calculator from './components/Calculator';

function App() {
  return (
    <div className="App">
      <main>
        <Calculator />
      </main>
      <footer className="App-footer">
        <p>This Calculator is Powered by 14 microservices written in 14 different Programming Languages</p>
      </footer>
      
      {/* GitHub Ribbon */}
      <a href="https://github.com/aterreno/scientific-calculator" 
         className="github-ribbon" 
         target="_blank" 
         rel="noopener noreferrer">
        <span>Fork me on GitHub</span>
      </a>
    </div>
  );
}

export default App;