
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { ThemeProvider } from '@/components/ThemeProvider';
import { FavouritesProvider } from '@/context/FavouritesContext';
import { Header } from '@/components/Header';
import { Toaster } from '@/components/ui/toaster';
import Index from '@/pages/Index';
import PropertyPage from '@/pages/PropertyPage';
import FavouritesPage from '@/pages/FavouritesPage';

/**
 * Main Application Component
 * Root component that sets up routing, context providers, and global layout
 * 
 * Architecture:
 * - BrowserRouter for client-side routing
 * - Context providers for global state (theme, favourites)
 * - Global header component for navigation
 * - Route definitions for all pages
 * - Toast notifications for user feedback
 * 
 * Provider Hierarchy:
 * 1. ThemeProvider - Manages light/dark theme state
 * 2. FavouritesProvider - Manages favourited properties with localStorage
 * 3. Router - Handles client-side navigation
 * 
 * Routes:
 * - / : Home page with search and results
 * - /property/:id : Individual property detail page  
 * - /favourites : Dedicated favourites management page
 */
function App() {
  return (
    // Theme Provider - Enables dark/light mode throughout app
    <ThemeProvider defaultTheme="light" storageKey="orangenest-theme">
      {/* Favourites Provider - Manages favourites state with localStorage persistence */}
      <FavouritesProvider>
        {/* Router Setup - Enables client-side navigation */}
        <Router>
          <div className="min-h-screen bg-background font-sans antialiased">
            {/* Global Header - Navigation, branding, and user controls */}
            <Header />
            
            {/* Main Content Routes */}
            <main>
              <Routes>
                {/* Home Page - Property search and results */}
                <Route path="/" element={<Index />} />
                
                {/* Property Detail Pages - Individual property information */}
                <Route path="/property/:id" element={<PropertyPage />} />
                
                {/* Favourites Page - Saved properties management */}
                <Route path="/favourites" element={<FavouritesPage />} />
              </Routes>
            </main>
            
            {/* Toast Notification System - User feedback for actions */}
            <Toaster />
          </div>
        </Router>
      </FavouritesProvider>
    </ThemeProvider>
  );
}

export default App;
