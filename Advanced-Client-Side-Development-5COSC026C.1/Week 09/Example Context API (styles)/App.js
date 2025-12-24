// App.js
import React from 'react';
import { ThemeProvider } from './components/ThemeContext';
import SomeComponent from './components/SomeComponent';
import './App.css'; // Import the CSS file

const App = () => {
  return (
    <ThemeProvider>
      <div className="container">
        <h1>My React App</h1>
        <SomeComponent />
      </div>
    </ThemeProvider>
  );
};

export default App;