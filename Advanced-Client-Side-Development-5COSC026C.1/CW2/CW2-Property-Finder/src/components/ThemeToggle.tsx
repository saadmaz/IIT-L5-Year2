
import { Moon, Sun } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useTheme } from './ThemeProvider';

/**
 * Theme toggle button component
 * Provides a user interface for switching between light and dark themes
 * 
 * Features:
 * - Animated icon transitions using CSS transforms
 * - Sun icon for light mode, moon icon for dark mode
 * - Smooth rotation animations when toggling
 * - Accessible with screen reader support
 * - Ghost button styling for minimal visual impact
 */
export function ThemeToggle() {
  // Get current theme and setter function from theme context
  const { theme, setTheme } = useTheme();

  return (
    <Button
      variant="ghost"
      size="sm"
      onClick={() => setTheme(theme === 'light' ? 'dark' : 'light')}
    >
      {/* Sun Icon - Visible in light mode, hidden in dark mode */}
      <Sun className="h-4 w-4 rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
      {/* Moon Icon - Hidden in light mode, visible in dark mode */}
      <Moon className="absolute h-4 w-4 rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
      {/* Screen reader text for accessibility */}
      <span className="sr-only">Toggle theme</span>
    </Button>
  );
}
