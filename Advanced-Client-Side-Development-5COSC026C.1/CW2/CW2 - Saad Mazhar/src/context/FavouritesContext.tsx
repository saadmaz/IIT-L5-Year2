
import { createContext, useContext, ReactNode } from 'react';
import { Property } from '@/types/property';
import { useLocalStorage } from '@/hooks/useLocalStorage';

/**
 * Type definition for the Favourites Context value
 * Defines all methods and state available to consuming components
 */
interface FavouritesContextType {
  favourites: Property[];                           // Array of favourited properties
  addToFavourites: (property: Property) => void;   // Add a property to favourites
  removeFromFavourites: (propertyId: number) => void; // Remove property by ID
  clearFavourites: () => void;                      // Clear all favourites
  isFavourite: (propertyId: number) => boolean;    // Check if property is favourited
}

// Create the context with undefined default (will be provided by FavouritesProvider)
const FavouritesContext = createContext<FavouritesContextType | undefined>(undefined);

/**
 * Props interface for the FavouritesProvider component
 */
interface FavouritesProviderProps {
  children: ReactNode; // Child components that will have access to favourites context
}

/**
 * Provider component that manages favourites state and localStorage persistence
 * Wraps the application to provide favourites functionality to all child components
 * 
 * Uses localStorage to persist favourites between browser sessions
 * 
 * @param children - React components that need access to favourites functionality
 */
export const FavouritesProvider: React.FC<FavouritesProviderProps> = ({ children }) => {
  // Use custom hook to manage favourites in localStorage with empty array as default
  const [favourites, setFavourites] = useLocalStorage<Property[]>('orangenest-favourites', []);

  /**
   * Add a property to the favourites list
   * Prevents duplicate entries by checking if property already exists
   * 
   * @param property - Property object to add to favourites
   */
  const addToFavourites = (property: Property) => {
    setFavourites(prev => {
      // Check if property is already in favourites to prevent duplicates
      const isAlreadyFavourited = prev.some(fav => fav.id === property.id);
      if (isAlreadyFavourited) {
        return prev; // Return unchanged array if already favourited
      }
      // Add new property to the beginning of the favourites array
      return [property, ...prev];
    });
  };

  /**
   * Remove a property from favourites by its ID
   * 
   * @param propertyId - Unique identifier of the property to remove
   */
  const removeFromFavourites = (propertyId: number) => {
    setFavourites(prev => prev.filter(property => property.id !== propertyId));
  };

  /**
   * Clear all favourites from the list and localStorage
   * Useful for "Clear All" functionality
   */
  const clearFavourites = () => {
    setFavourites([]);
  };

  /**
   * Check if a property is currently in the favourites list
   * 
   * @param propertyId - ID of the property to check
   * @returns boolean indicating if property is favourited
   */
  const isFavourite = (propertyId: number): boolean => {
    return favourites.some(property => property.id === propertyId);
  };

  // Context value object containing all favourites state and methods
  const contextValue: FavouritesContextType = {
    favourites,
    addToFavourites,
    removeFromFavourites,
    clearFavourites,
    isFavourite,
  };

  return (
    <FavouritesContext.Provider value={contextValue}>
      {children}
    </FavouritesContext.Provider>
  );
};

/**
 * Custom hook to access the Favourites Context
 * Provides easy access to favourites state and methods from any component
 * 
 * @throws Error if used outside of FavouritesProvider
 * @returns FavouritesContextType object with all favourites functionality
 */
export const useFavourites = (): FavouritesContextType => {
  const context = useContext(FavouritesContext);
  
  // Ensure hook is used within the provider
  if (context === undefined) {
    throw new Error('useFavourites must be used within a FavouritesProvider');
  }
  
  return context;
};
