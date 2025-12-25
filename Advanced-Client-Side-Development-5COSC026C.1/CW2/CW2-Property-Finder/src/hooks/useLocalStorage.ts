
import { useState, useEffect } from 'react';

/**
 * Custom React hook for managing localStorage with automatic JSON serialization
 * Provides a React state-like interface for localStorage values with type safety
 * 
 * @template T - The type of data to store in localStorage
 * @param key - The localStorage key to use for storage
 * @param initialValue - Default value to use if no stored value exists
 * @returns Tuple containing [storedValue, setValue] similar to useState
 */
export function useLocalStorage<T>(key: string, initialValue: T) {
  // State to store our value - initialized with value from localStorage or initialValue
  const [storedValue, setStoredValue] = useState<T>(() => {
    try {
      // Get from localStorage by key
      const item = window.localStorage.getItem(key);
      // Parse stored JSON or return initialValue if nothing stored
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      // If error reading localStorage, log and return initialValue
      console.warn(`Error reading localStorage key "${key}":`, error);
      return initialValue;
    }
  });

  /**
   * Function to update both state and localStorage
   * Accepts either a value directly or a function that receives current value
   * 
   * @param value - New value or function that returns new value
   */
  const setValue = (value: T | ((val: T) => T)) => {
    try {
      // Allow value to be a function so we have the same API as useState
      const valueToStore = value instanceof Function ? value(storedValue) : value;
      
      // Save state
      setStoredValue(valueToStore);
      
      // Save to localStorage with JSON serialization
      window.localStorage.setItem(key, JSON.stringify(valueToStore));
    } catch (error) {
      // If error saving to localStorage, log the error
      console.error(`Error setting localStorage key "${key}":`, error);
    }
  };

  return [storedValue, setValue] as const;
}
