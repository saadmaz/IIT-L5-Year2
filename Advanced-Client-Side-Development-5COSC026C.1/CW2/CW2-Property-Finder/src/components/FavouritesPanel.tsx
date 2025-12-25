
import { Heart, Trash2 } from 'lucide-react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { ScrollArea } from '@/components/ui/scroll-area';
import { useFavourites } from '@/context/FavouritesContext';
import { formatPrice } from '@/utils/filterUtils';
import { Link } from 'react-router-dom';

/**
 * Favourites Panel Component
 * Displays user's favourited properties in a sidebar panel format
 * 
 * Features:
 * - Scrollable list of favourited properties
 * - Individual property preview with image, price, and details
 * - Remove individual favourites functionality
 * - Clear all favourites option
 * - Empty state with helpful messaging
 * - Clickable property links to detail pages
 * - Image error handling with fallback
 * - Responsive design for different screen sizes
 */
export const FavouritesPanel = () => {
  // Get favourites state and management functions from context
  const { favourites, removeFromFavourites, clearFavourites } = useFavourites();

  // Empty State - Show when no favourites are saved
  if (favourites.length === 0) {
    return (
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Heart className="h-5 w-5 text-orange-500" />
            Favourites
          </CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-muted-foreground text-center py-8">
            No favourites yet. Click the heart icon on any property to add it here.
          </p>
        </CardContent>
      </Card>
    );
  }

  // Active State - Show favourites list with management options
  return (
    <Card>
      <CardHeader>
        <div className="flex items-center justify-between">
          {/* Panel Title with Count */}
          <CardTitle className="flex items-center gap-2">
            <Heart className="h-5 w-5 text-orange-500" />
            Favourites ({favourites.length})
          </CardTitle>
          {/* Clear All Button */}
          <Button
            variant="ghost"
            size="sm"
            onClick={clearFavourites}
            className="text-destructive hover:text-destructive"
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      </CardHeader>
      <CardContent>
        {/* Scrollable Container for Favourites List */}
        <ScrollArea className="h-96">
          <div className="space-y-3">
            {favourites.map((property) => (
              <div key={property.id} className="flex items-center gap-3 p-3 border rounded-lg hover:bg-muted/50 transition-colors">
                {/* Property Thumbnail Image */}
                <img 
                  src={property.picture} 
                  alt={property.location}
                  className="w-16 h-16 rounded object-cover"
                  onError={(e) => {
                    // Fallback image when main image fails to load - Base64 encoded placeholder
                    (e.target as HTMLImageElement).src = 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjQiIGhlaWdodD0iNjQiIHZpZXdCb3g9IjAgMCA2NCA2NCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHJlY3Qgd2lkdGg9IjY0IiBoZWlnaHQ9IjY0IiBmaWxsPSIjRjVGNUY1Ii8+CjxwYXRoIGQ9Ik0yMCAyNEgyMFYyMEg0NFYyNEg0NFY0NEgyMFYyNFoiIHN0cm9rZT0iI0Q0RDRENyIgc3Ryb2tlLXdpZHRoPSIyIi8+Cjwvc3ZnPgo=';
                  }}
                />
                {/* Property Information - Clickable link to detail page */}
                <div className="flex-1 min-w-0">
                  <Link to={`/property/${property.id}`} className="block">
                    <p className="font-medium text-sm">{formatPrice(property.price)}</p>
                    <p className="text-xs text-muted-foreground truncate">{property.location}</p>
                    <p className="text-xs text-muted-foreground">{property.bedrooms} bed {property.type}</p>
                  </Link>
                </div>
                {/* Remove Button - Delete individual favourite */}
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => removeFromFavourites(property.id)}
                  className="text-destructive hover:text-destructive"
                >
                  <Trash2 className="h-3 w-3" />
                </Button>
              </div>
            ))}
          </div>
        </ScrollArea>
      </CardContent>
    </Card>
  );
};
