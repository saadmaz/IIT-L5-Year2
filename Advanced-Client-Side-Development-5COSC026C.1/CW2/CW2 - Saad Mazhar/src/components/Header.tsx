
import { Link } from 'react-router-dom';
import { Home, Heart } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { ThemeToggle } from './ThemeToggle';
import { useFavourites } from '@/context/FavouritesContext';

/**
 * Main application header component
 * Provides site navigation, branding, and key user interface elements
 * 
 * Features:
 * - OrangeNest brand logo and name
 * - Favourites button with count badge
 * - Theme toggle for light/dark mode
 * - Responsive design with sticky positioning
 * - Backdrop blur effect for modern appearance
 */
export const Header = () => {
  // Get favourites count from context to display in badge
  const { favourites } = useFavourites();

  return (
    <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container flex h-16 items-center justify-between">
        {/* Brand Section - Logo and Site Name */}
        <Link to="/" className="flex items-center space-x-2">
          {/* Logo Icon - Orange gradient background with home icon */}
          <div className="w-8 h-8 rounded-lg gradient-orange flex items-center justify-center">
            <Home className="h-5 w-5 text-white" />
          </div>
          {/* Site Name - Gradient text effect */}
          <span className="text-xl font-bold bg-gradient-to-r from-orange-500 to-orange-600 bg-clip-text text-transparent">
            OrangeNest
          </span>
        </Link>

        {/* Navigation Section - Right side controls */}
        <nav className="flex items-center space-x-4">
          {/* Favourites Button - Links to favourites page */}
          <Link to="/favourites">
            <Button variant="ghost" size="sm" className="relative">
              <Heart className="h-4 w-4" />
              {/* Text label - Hidden on small screens to save space */}
              <span className="ml-2 hidden sm:inline">Favourites</span>
              {/* Count Badge - Shows when favourites exist */}
              {favourites.length > 0 && (
                <span className="absolute -top-2 -right-2 h-5 w-5 rounded-full bg-orange-500 text-xs text-white flex items-center justify-center">
                  {favourites.length}
                </span>
              )}
            </Button>
          </Link>
          {/* Theme Toggle Button - Switches between light and dark modes */}
          <ThemeToggle />
        </nav>
      </div>
    </header>
  );
};
