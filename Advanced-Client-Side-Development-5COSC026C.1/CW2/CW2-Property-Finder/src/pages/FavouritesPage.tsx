
import { Link } from 'react-router-dom';
import { ArrowLeft, Heart } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { PropertyGrid } from '@/components/PropertyGrid';
import { useFavourites } from '@/context/FavouritesContext';

/**
 * Favourites Page Component  
 * Dedicated page for viewing and managing all favourited properties
 * 
 * Features:
 * - Full-screen view of all favourited properties
 * - Breadcrumb navigation back to main search
 * - Property count display with proper pluralization
 * - Clear all favourites functionality 
 * - Empty state with call-to-action
 * - Reuses PropertyGrid component for consistent layout
 * - Responsive design for all screen sizes
 * 
 * URL: /favourites
 * Accessible via header navigation or direct URL
 */
const FavouritesPage = () => {
  // Get favourites state and management functions from context
  const { favourites, clearFavourites } = useFavourites();

  return (
    <div className="container py-8">
      {/* Navigation Section - Breadcrumb back to search */}
      <div className="mb-6">
        <Link to="/">
          <Button variant="ghost" className="mb-4">
            <ArrowLeft className="h-4 w-4 mr-2" />
            Back to Search
          </Button>
        </Link>
      </div>

      {/* Page Header Section */}
      <div className="flex items-center justify-between mb-8">
        <div>
          {/* Page Title with Heart Icon */}
          <h1 className="text-3xl font-bold mb-2 flex items-center gap-2">
            <Heart className="h-8 w-8 text-orange-500" />
            Your Favourites
          </h1>
          {/* Property Count with Smart Pluralization */}
          <p className="text-muted-foreground">
            {favourites.length} {favourites.length === 1 ? 'property' : 'properties'} saved
          </p>
        </div>
        
        {/* Clear All Button - Only show when favourites exist */}
        {favourites.length > 0 && (
          <Button
            variant="outline"
            onClick={clearFavourites}
            className="text-destructive hover:text-destructive"
          >
            Clear All
          </Button>
        )}
      </div>

      {/* Content Section - Empty state or property grid */}
      {favourites.length === 0 ? (
        // Empty State - No favourites saved yet
        <div className="text-center py-16">
          <Heart className="h-16 w-16 text-muted-foreground mx-auto mb-4" />
          <h2 className="text-xl font-semibold mb-2">No favourites yet</h2>
          <p className="text-muted-foreground mb-6">
            Start browsing properties and click the heart icon to save your favourites here.
          </p>
          {/* Call-to-Action Button */}
          <Link to="/">
            <Button className="gradient-orange text-white">
              Browse Properties
            </Button>
          </Link>
        </div>
      ) : (
        // Active State - Show favourites in grid layout
        // Reuses PropertyGrid component for consistent display and functionality
        <PropertyGrid properties={favourites} />
      )}
    </div>
  );
};

export default FavouritesPage;
