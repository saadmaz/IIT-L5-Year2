
import React from 'react';
import { Link } from 'react-router-dom';
import { Heart, MapPin, Bed, Calendar, Home } from 'lucide-react';
import { Property } from '../types/Property';
import { Card, CardContent } from '@/components/ui/card';

interface PropertyCardProps {
  property: Property;
  isFavorite: boolean;
  onFavorite: (property: Property) => void;
}

/**
 * PropertyCard Component
 * 
 * This component displays a single property in a card format with:
 * - Property image with overlay information
 * - Interactive favorite button
 * - Property details (price, location, bedrooms, etc.)
 * - Hover effects and smooth animations
 * - Responsive design for different screen sizes
 * 
 * The card is clickable and navigates to the property detail page.
 * 
 * @param property - The property object containing all property information
 * @param isFavorite - Boolean indicating if this property is in favorites
 * @param onFavorite - Callback function to handle favorite toggle
 */
const PropertyCard: React.FC<PropertyCardProps> = ({ property, isFavorite, onFavorite }) => {
  /**
   * Handle favorite button click
   * Prevents event bubbling to avoid navigation when clicking the favorite button
   */
  const handleFavoriteClick = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    onFavorite(property);
  };

  return (
    <Card className="group overflow-hidden hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-2 bg-white dark:bg-gray-800 border-0 shadow-lg">
      <Link to={`/property/${property.id}`}>
        <div className="relative overflow-hidden">
          {/* 
            PROPERTY IMAGE SECTION
            
            TODO - REPLACE WITH ACTUAL PROPERTY IMAGES:
            1. Store high-quality property images in your public/images folder
            2. Update the property.picture URLs in properties.json to point to these images
            3. Consider using a CDN for better performance
            4. Implement lazy loading for better performance: add loading="lazy" attribute
            
            Current: Using placeholder image from properties.json
            Recommended: Use actual property photos (1200x800px minimum for quality)
          */}
          <img
            src={property.picture}
            alt={`${property.type} in ${property.location}`}
            className="w-full h-64 object-cover group-hover:scale-110 transition-transform duration-500"
            loading="lazy"
          />
          
          {/* Image overlay gradient for better text readability */}
          <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent" />
          
          {/* Favorite button with dynamic styling */}
          <button
            onClick={handleFavoriteClick}
            className={`absolute top-4 right-4 p-3 rounded-full backdrop-blur-md transition-all duration-300 transform hover:scale-110 ${
              isFavorite 
                ? 'bg-red-500/90 text-white shadow-lg' 
                : 'bg-white/90 text-gray-700 hover:bg-red-500/90 hover:text-white shadow-md'
            }`}
            aria-label={isFavorite ? 'Remove from favorites' : 'Add to favorites'}
          >
            <Heart className={`w-5 h-5 ${isFavorite ? 'fill-current' : ''}`} />
          </button>
          
          {/* Property type badge */}
          <div className="absolute bottom-4 left-4 bg-orange-500/90 backdrop-blur-sm px-4 py-2 rounded-full">
            <div className="flex items-center space-x-2">
              <Home className="w-4 h-4 text-white" />
              <span className="text-sm font-semibold text-white">{property.type}</span>
            </div>
          </div>
        </div>
        
        {/* Property information section */}
        <CardContent className="p-6 space-y-4">
          {/* Price and date row */}
          <div className="flex justify-between items-start">
            <h3 className="text-3xl font-bold text-gray-900 dark:text-white">
              £{property.price.toLocaleString()}
            </h3>
            <div className="flex items-center text-sm text-gray-500 dark:text-gray-400 bg-gray-100 dark:bg-gray-700 px-3 py-1 rounded-full">
              <Calendar className="w-4 h-4 mr-1" />
              {new Date(property.added).toLocaleDateString('en-GB', {
                day: 'numeric',
                month: 'short',
                year: 'numeric'
              })}
            </div>
          </div>
          
          {/* Location information */}
          <div className="flex items-center text-gray-600 dark:text-gray-300">
            <MapPin className="w-5 h-5 mr-2 flex-shrink-0 text-orange-500" />
            <span className="truncate font-medium">{property.location}</span>
          </div>
          
          {/* Property details row */}
          <div className="flex items-center justify-between pt-2">
            <div className="flex items-center text-gray-600 dark:text-gray-300 bg-blue-50 dark:bg-blue-900/20 px-3 py-2 rounded-lg">
              <Bed className="w-4 h-4 mr-2 text-blue-500" />
              <span className="font-medium">
                {property.bedrooms} bedroom{property.bedrooms !== 1 ? 's' : ''}
              </span>
            </div>
            <span className="text-sm bg-orange-100 dark:bg-orange-900/30 text-orange-800 dark:text-orange-300 px-3 py-2 rounded-full font-semibold">
              {property.postcode}
            </span>
          </div>
          
          {/* Property description */}
          <p className="text-gray-600 dark:text-gray-300 text-sm leading-relaxed line-clamp-2 pt-2">
            {property.description}
          </p>
          
          {/* Tenure information */}
          <div className="pt-2 border-t border-gray-200 dark:border-gray-700">
            <span className="text-xs text-gray-500 dark:text-gray-400 font-medium">
              Tenure: {property.tenure}
            </span>
          </div>
        </CardContent>
      </Link>
    </Card>
  );
};

export default PropertyCard;
