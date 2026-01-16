
import { useState } from 'react';
import { Link } from 'react-router-dom';
import { Heart, Home } from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { useFavourites } from '@/context/FavouritesContext';
import { Property } from '@/types/property';
import { formatPrice, formatDate } from '@/utils/filterUtils';

interface PropertyCardProps {
  property: Property;
}

export const PropertyCard: React.FC<PropertyCardProps> = ({ property }) => {
  // Favourites context for managing liked properties
  const { addToFavourites, removeFromFavourites, isFavourite } = useFavourites();
  // Track image loading errors for fallback display
  const [imageError, setImageError] = useState(false);
  // Check if current property is already favourited
  const isFav = isFavourite(property.id);

  // Handle favourite button click - prevent event bubbling to card link
  const handleFavouriteClick = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    
    if (isFav) {
      removeFromFavourites(property.id);
    } else {
      addToFavourites(property);
    }
  };

  // Handle image loading failure - show fallback icon
  const handleImageError = () => {
    setImageError(true);
  };

  return (
    <Card className="hover-lift group overflow-hidden">
      <Link to={`/property/${property.id}`}>
        {/* Property Image Section */}
        <div className="relative">
          {!imageError ? (
            <img
              src={property.picture}
              alt={property.location}
              className="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300"
              onError={handleImageError}
            />
          ) : (
            // Fallback display when image fails to load
            <div className="w-full h-48 bg-gradient-to-br from-orange-100 to-orange-200 flex items-center justify-center">
              <Home className="h-12 w-12 text-orange-400" />
            </div>
          )}
          
          {/* Favourite Button - positioned over image */}
          <Button
            variant="ghost"
            size="sm"
            className="absolute top-2 right-2 bg-white/90 hover:bg-white shadow-md"
            onClick={handleFavouriteClick}
          >
            <Heart 
              className={`h-4 w-4 ${isFav ? 'fill-orange-500 text-orange-500' : 'text-gray-600'}`}
            />
          </Button>
          
          {/* Property Type Badge */}
          <Badge className="absolute bottom-2 left-2 bg-orange-500 hover:bg-orange-600">
            {property.type}
          </Badge>
        </div>

        {/* Property Information Section */}
        <CardContent className="p-4">
          <div className="space-y-2">
            {/* Price and Bedroom Count */}
            <div className="flex justify-between items-start">
              <h3 className="font-semibold text-lg">{formatPrice(property.price)}</h3>
              <span className="text-sm text-muted-foreground">{property.bedrooms} bed</span>
            </div>
            
            {/* Location */}
            <p className="font-medium text-orange-600">{property.location}</p>
            
            {/* Description Preview */}
            <p className="text-sm text-muted-foreground line-clamp-2">
              {property.description}
            </p>
            
            {/* Additional Property Details */}
            <div className="flex justify-between items-center text-xs text-muted-foreground">
              <span>{property.tenure}</span>
              <span>Added {formatDate(property.added)}</span>
            </div>
          </div>
        </CardContent>
      </Link>
    </Card>
  );
};
