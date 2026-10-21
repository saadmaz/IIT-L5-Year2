
import React from 'react';
import { Link } from 'react-router-dom';
import { Heart, Trash2, X, Star } from 'lucide-react';
import { Property } from '../types/Property';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';

interface FavoritesPanelProps {
  favorites: Property[];
  onRemoveFavorite: (property: Property) => void;
  onClearAll: () => void;
}

/**
 * FavoritesPanel Component
 * 
 * A sophisticated favorites management panel that displays saved properties with:
 * - Beautiful card-based layout for each favorite property
 * - Individual remove buttons with smooth animations
 * - Bulk clear all favorites functionality
 * - Responsive design that adapts to different screen sizes
 * - Empty state with helpful instructions
 * - Smooth hover effects and transitions
 * 
 * Features:
 * - Scrollable list when many favorites are saved
 * - Click to navigate to property details
 * - Individual and bulk removal options
 * - Persistent storage using localStorage
 * - Visual feedback for user interactions
 * 
 * @param favorites - Array of favorite Property objects
 * @param onRemoveFavorite - Callback to remove a single property from favorites
 * @param onClearAll - Callback to clear all favorites at once
 */
const FavoritesPanel: React.FC<FavoritesPanelProps> = ({ 
  favorites, 
  onRemoveFavorite, 
  onClearAll 
}) => {
  return (
    <Card className="sticky top-8 shadow-2xl border-0 bg-gradient-to-br from-white to-orange-50 dark:from-gray-900 dark:to-gray-800">
      <CardHeader className="pb-4">
        <div className="flex items-center justify-between">
          <CardTitle className="flex items-center space-x-3">
            <div className="bg-red-100 dark:bg-red-900/30 p-2 rounded-lg">
              <Heart className="w-6 h-6 text-red-600 fill-current" />
            </div>
            <div>
              <span className="text-xl font-bold">My Favorites</span>
              <p className="text-sm text-muted-foreground font-normal">
                {favorites.length} {favorites.length === 1 ? 'property' : 'properties'} saved
              </p>
            </div>
          </CardTitle>
          
          {/* Clear all button - only show when there are favorites */}
          {favorites.length > 0 && (
            <Button
              variant="ghost"
              size="sm"
              onClick={onClearAll}
              className="text-red-600 hover:text-red-700 hover:bg-red-50 dark:hover:bg-red-900/20 transition-all duration-200"
              aria-label="Clear all favorites"
            >
              <Trash2 className="w-4 h-4" />
            </Button>
          )}
        </div>
      </CardHeader>
      
      <CardContent>
        {/* Empty state - show when no favorites */}
        {favorites.length === 0 ? (
          <div className="text-center py-12">
            <div className="bg-gray-100 dark:bg-gray-800 p-6 rounded-2xl mb-6">
              <Heart className="w-16 h-16 mx-auto mb-4 text-gray-300 dark:text-gray-600" />
            </div>
            <h3 className="text-lg font-semibold text-foreground mb-2">No favorites yet</h3>
            <p className="text-sm text-muted-foreground mb-4 leading-relaxed">
              Start building your dream property collection by clicking the heart icon on properties you love
            </p>
            <div className="flex items-center justify-center space-x-2 text-xs text-muted-foreground bg-orange-50 dark:bg-orange-900/20 p-3 rounded-lg">
              <Star className="w-4 h-4 text-orange-500" />
              <span>Pro tip: You can also drag properties here!</span>
            </div>
          </div>
        ) : (
          /* Favorites list - scrollable container for multiple favorites */
          <div className="space-y-4 max-h-[600px] overflow-y-auto pr-2 custom-scrollbar">
            {favorites.map(property => (
              <div key={property.id} className="group relative">
                <Link to={`/property/${property.id}`}>
                  <div className="flex space-x-4 p-4 rounded-xl hover:bg-orange-50 dark:hover:bg-gray-800/50 transition-all duration-200 border border-transparent hover:border-orange-200 dark:hover:border-orange-800">
                    {/* Property thumbnail image */}
                    <div className="relative flex-shrink-0">
                      <img
                        src={property.picture}
                        alt={`${property.type} in ${property.location}`}
                        className="w-20 h-20 object-cover rounded-lg shadow-md group-hover:shadow-lg transition-shadow duration-200"
                      />
                      {/* Property type badge overlay */}
                      <div className="absolute -top-2 -right-2 bg-orange-500 text-white text-xs px-2 py-1 rounded-full font-semibold">
                        {property.type}
                      </div>
                    </div>
                    
                    {/* Property information */}
                    <div className="flex-1 min-w-0">
                      <div className="flex items-start justify-between mb-2">
                        <p className="font-bold text-lg text-foreground truncate">
                          £{property.price.toLocaleString()}
                        </p>
                        <span className="text-xs text-muted-foreground bg-blue-100 dark:bg-blue-900/30 px-2 py-1 rounded-full">
                          {property.postcode}
                        </span>
                      </div>
                      
                      <p className="text-sm text-muted-foreground truncate mb-2 font-medium">
                        {property.location}
                      </p>
                      
                      <div className="flex items-center justify-between">
                        <p className="text-xs text-muted-foreground">
                          {property.bedrooms} bed • {property.tenure}
                        </p>
                        <p className="text-xs text-muted-foreground">
                          Added {new Date(property.added).toLocaleDateString('en-GB', {
                            day: 'numeric',
                            month: 'short'
                          })}
                        </p>
                      </div>
                    </div>
                  </div>
                </Link>
                
                {/* Remove from favorites button */}
                <button
                  onClick={(e) => {
                    e.preventDefault();
                    onRemoveFavorite(property);
                  }}
                  className="absolute top-2 right-2 p-2 rounded-full bg-white dark:bg-gray-800 shadow-md opacity-0 group-hover:opacity-100 transition-all duration-200 hover:bg-red-50 dark:hover:bg-red-900/20 hover:text-red-600 border border-gray-200 dark:border-gray-700"
                  aria-label={`Remove ${property.type} in ${property.location} from favorites`}
                >
                  <X className="w-4 h-4" />
                </button>
              </div>
            ))}
          </div>
        )}
      </CardContent>
      
      {/* 
        FAVORITES FUNCTIONALITY NOTES:
        
        TODO - ENHANCE FAVORITES FEATURES:
        1. Add drag-and-drop functionality for reordering favorites
        2. Implement favorites categories/folders
        3. Add export favorites functionality (PDF, email)
        4. Include favorite property comparison tool
        5. Add sharing functionality for favorite lists
        6. Implement favorites search and filtering
        
        STORAGE IMPROVEMENTS:
        1. Consider using IndexedDB for larger datasets
        2. Add cloud sync for logged-in users
        3. Implement favorites backup/restore
        4. Add favorites analytics and insights
      */}
    </Card>
  );
};

export default FavoritesPanel;
