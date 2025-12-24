// SomeComponent.js
import React, { useContext } from 'react';
import { ThemeContext } from './ThemeContext';

const SomeComponent = () => {
  const { theme, toggleTheme } = useContext(ThemeContext);

  return (
    <div className={`some-component ${theme === 'light' ? 'light-theme' : 'dark-theme'}`}>
      <p>Current Theme: {theme}</p>
      <button onClick={toggleTheme}>Toggle Theme</button>
    </div>
  );
};

export default SomeComponent;