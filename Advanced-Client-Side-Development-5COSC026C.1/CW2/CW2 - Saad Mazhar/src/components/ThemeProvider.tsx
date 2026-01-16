
import { createContext, useContext, useEffect, useState } from 'react';

// Type definitions for theme system
type Theme = 'dark' | 'light' | 'system';

/**
 * Props interface for ThemeProvider component
 */
type ThemeProviderProps = {
  children: React.ReactNode;    // Child components that need theme access
  defaultTheme?: Theme;         // Initial theme if not stored in localStorage
  storageKey?: string;          // Key for localStorage persistence
};

/**
 * Theme context state interface
 * Defines the structure of theme-related state and methods
 */
type ThemeProviderState = {
  theme: Theme;                 // Current theme setting
  setTheme: (theme: Theme) => void; // Function to update theme
};

// Default context state - used as fallback
const initialState: ThemeProviderState = {
  theme: 'system',
  setTheme: () => null,
};

// Create React context for theme management
const ThemeProviderContext = createContext<ThemeProviderState>(initialState);

/**
 * Theme Provider Component
 * Manages application-wide theme state with localStorage persistence
 * 
 * Supports three theme modes:
 * - 'light': Forces light theme
 * - 'dark': Forces dark theme  
 * - 'system': Follows user's system preference
 * 
 * Features:
 * - Automatic system preference detection
 * - localStorage persistence across sessions
 * - Dynamic CSS class management on document root
 * - Context-based theme access for all child components
 * 
 * @param children - React components that need theme access
 * @param defaultTheme - Default theme if none stored (defaults to 'system')
 * @param storageKey - localStorage key for theme persistence
 */
export function ThemeProvider({
  children,
  defaultTheme = 'system',
  storageKey = 'orangenest-theme',
  ...props
}: ThemeProviderProps) {
  // Initialize theme from localStorage or use default
  const [theme, setTheme] = useState<Theme>(
    () => (localStorage.getItem(storageKey) as Theme) || defaultTheme
  );

  // Effect to apply theme changes to the DOM
  useEffect(() => {
    const root = window.document.documentElement;

    // Remove existing theme classes
    root.classList.remove('light', 'dark');

    // Handle system theme preference
    if (theme === 'system') {
      // Detect user's system preference using media query
      const systemTheme = window.matchMedia('(prefers-color-scheme: dark)')
        .matches
        ? 'dark'
        : 'light';

      // Apply system-detected theme class
      root.classList.add(systemTheme);
      return;
    }

    // Apply explicitly selected theme
    root.classList.add(theme);
  }, [theme]);

  // Context value object with theme state and updater
  const value = {
    theme,
    setTheme: (theme: Theme) => {
      // Persist theme choice to localStorage
      localStorage.setItem(storageKey, theme);
      // Update component state
      setTheme(theme);
    },
  };

  return (
    <ThemeProviderContext.Provider {...props} value={value}>
      {children}
    </ThemeProviderContext.Provider>
  );
}

/**
 * Custom hook to access theme context
 * Provides easy access to theme state and setter from any component
 * 
 * @throws Error if used outside ThemeProvider
 * @returns Theme context object with current theme and setter function
 */
export const useTheme = () => {
  const context = useContext(ThemeProviderContext);

  // Ensure hook is used within provider
  if (context === undefined)
    throw new Error('useTheme must be used within a ThemeProvider');

  return context;
};
