// import React from 'react';
// import { createRoot } from 'react-dom/client';
// import './index.css';
// import App from './App.jsx';

// createRoot(document.getElementById('root')).render(
//   <React.StrictMode>
//     <App />
//   </React.StrictMode>
// );

import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './index.css'

// Make sure this line correctly targets your root div
const root = ReactDOM.createRoot(document.getElementById('root'))

// Add console log for debugging
console.log('Rendering React app')

root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
)