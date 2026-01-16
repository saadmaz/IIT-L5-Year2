import { useParams, Link } from 'react-router-dom';
import { ArrowLeft, Heart, MapPin, Calendar, Home as HomeIcon, Bed } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { ImageGallery } from '@/components/ImageGallery';
import { useFavourites } from '@/context/FavouritesContext';
import { formatPrice, formatDate } from '@/utils/filterUtils';
import propertiesData from '@/data/properties.json';
import { Property } from '@/types/property';

/**
 * Property Detail Page Component
 * Displays comprehensive information about a single property
 * 
 * Features:
 * - Full property image gallery with carousel navigation
 * - Detailed property information and specifications  
 * - Tabbed content sections (Description, Floor Plan, Location)
 * - Favourite/unfavourite functionality
 * - Breadcrumb navigation back to search
 * - Property status badges and key details
 * - Responsive layout for all screen sizes
 * - 404 handling for non-existent properties
 * 
 * URL Structure: /property/:id
 * - :id parameter corresponds to property.id from JSON data
 */
const PropertyPage = () => {
  // Extract property ID from URL parameters
  const { id } = useParams<{ id: string }>();
  
  // Get favourites functionality from context
  const { addToFavourites, removeFromFavourites, isFavourite } = useFavourites();

  // Find the specific property from our JSON data
  const property = propertiesData.find(p => p.id === parseInt(id || '0')) as Property | undefined;

  // Handle case where property doesn't exist (404-like behavior)
  if (!property) {
    return (
      <div className="container py-8">
        {/* Navigation Back to Search */}
        <Link to="/">
          <Button variant="ghost" className="mb-6">
            <ArrowLeft className="h-4 w-4 mr-2" />
            Back to Search
          </Button>
        </Link>
        
        {/* 404 Error Message */}
        <div className="text-center py-16">
          <HomeIcon className="h-16 w-16 text-muted-foreground mx-auto mb-4" />
          <h1 className="text-2xl font-bold mb-2">Property Not Found</h1>
          <p className="text-muted-foreground mb-6">
            The property you're looking for doesn't exist or may have been removed.
          </p>
          <Link to="/">
            <Button className="gradient-orange text-white">
              Browse All Properties
            </Button>
          </Link>
        </div>
      </div>
    );
  }

  // Check if current property is favourited
  const isFav = isFavourite(property.id);

  /**
   * Handle favourite button click
   * Toggles property between favourited and non-favourited state
   */
  const handleFavouriteClick = () => {
    if (isFav) {
      removeFromFavourites(property.id);
    } else {
      addToFavourites(property);
    }
  };

  return (
    <div className="container py-8">
      {/* Navigation Section */}
      <div className="mb-6">
        <Link to="/">
          <Button variant="ghost" className="mb-4">
            <ArrowLeft className="h-4 w-4 mr-2" />
            Back to Search
          </Button>
        </Link>
      </div>

      {/* Property Header Section */}
      <div className="flex flex-col lg:flex-row gap-8 mb-8">
        {/* Image Gallery - Takes up 2/3 of width on large screens */}
        <div className="lg:w-2/3">
          <ImageGallery images={property.images} />
        </div>

        {/* Property Information Panel - Takes up 1/3 of width on large screens */}
        <div className="lg:w-1/3">
          <Card>
            <CardHeader>
              {/* Price and Favourite Button Row */}
              <div className="flex items-start justify-between">
                <div>
                  <CardTitle className="text-3xl font-bold text-orange-600">
                    {formatPrice(property.price)}
                  </CardTitle>
                  <div className="flex items-center gap-2 mt-2">
                    <Badge variant="secondary">{property.type}</Badge>
                    <Badge variant="outline">{property.tenure}</Badge>
                  </div>
                </div>
                {/* Favourite Toggle Button */}
                <Button
                  variant="outline"
                  size="icon"
                  onClick={handleFavouriteClick}
                  className={isFav ? 'text-orange-500 border-orange-500' : ''}
                >
                  <Heart className={`h-5 w-5 ${isFav ? 'fill-current' : ''}`} />
                </Button>
              </div>
            </CardHeader>
            
            <CardContent className="space-y-4">
              {/* Location Information */}
              <div className="flex items-center gap-2">
                <MapPin className="h-4 w-4 text-muted-foreground" />
                <span className="font-medium">{property.location}</span>
              </div>

              {/* Property Specifications */}
              <div className="flex items-center gap-2">
                <Bed className="h-4 w-4 text-muted-foreground" />
                <span>{property.bedrooms} Bedroom{property.bedrooms !== 1 ? 's' : ''}</span>
              </div>

              {/* Date Added */}
              <div className="flex items-center gap-2">
                <Calendar className="h-4 w-4 text-muted-foreground" />
                <span>Added {formatDate(property.added)}</span>
              </div>

              {/* External Link Button */}
              <Button 
                className="w-full gradient-orange text-white" 
                asChild
              >
                <a href={property.url} target="_blank" rel="noopener noreferrer">
                  View on External Site
                </a>
              </Button>
            </CardContent>
          </Card>
        </div>
      </div>

      {/* Tabbed Content Section */}
      <Tabs defaultValue="description" className="space-y-6">
        {/* Tab Navigation */}
        <TabsList className="grid w-full grid-cols-3">
          <TabsTrigger value="description">Description</TabsTrigger>
          <TabsTrigger value="floorplan">Floor Plan</TabsTrigger>
          <TabsTrigger value="location">Location</TabsTrigger>
        </TabsList>

        {/* Description Tab Content */}
        <TabsContent value="description">
          <Card>
            <CardHeader>
              <CardTitle>Property Description</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-muted-foreground leading-relaxed">
                {property.description}
              </p>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Floor Plan Tab Content */}
        <TabsContent value="floorplan">
          <Card>
            <CardHeader>
              <CardTitle>Floor Plan</CardTitle>
            </CardHeader>
            <CardContent>
              {/* Placeholder for floor plan - Could be replaced with actual floor plan images */}
              <div className="aspect-video bg-gradient-to-br from-orange-50 to-orange-100 rounded-lg flex items-center justify-center border-2 border-dashed border-orange-200">
                <div className="text-center">
                  <HomeIcon className="h-12 w-12 text-orange-300 mx-auto mb-2" />
                  <p className="text-orange-600 font-medium">Floor Plan Coming Soon</p>
                  <p className="text-orange-500 text-sm">Contact agent for detailed layout information</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Location Tab Content */}
        <TabsContent value="location">
          <Card>
            <CardHeader>
              <CardTitle>Location & Map</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <p className="text-muted-foreground">
                  <strong>Address:</strong> {property.location}
                </p>
                <p className="text-muted-foreground">
                  <strong>Postcode:</strong> {property.postcode}
                </p>
                {/* Google Maps Embed */}
                <div className="aspect-video rounded-lg overflow-hidden border-2 border-orange-200">
                  {property.googleMapsUrl ? (
                    <iframe
                      src={property.googleMapsUrl.replace('maps.app.goo.gl', 'www.google.com/maps/embed?pb=')}
                      width="100%"
                      height="100%"
                      style={{ border: 0 }}
                      allowFullScreen={true}
                      loading="lazy"
                      referrerPolicy="no-referrer-when-downgrade"
                      title="Google Map"
                    />
                  ) : (
                    <iframe
                      src={`https://www.google.com/maps?q=${encodeURIComponent(property.location)}&output=embed`}
                      width="100%"
                      height="100%"
                      style={{ border: 0 }}
                      allowFullScreen={true}
                      loading="lazy"
                      referrerPolicy="no-referrer-when-downgrade"
                      title="Google Map"
                    />
                  )}
                </div>

                {/* Link to Google Maps */}
                {property.googleMapsUrl && (
                  <a
                    href={property.googleMapsUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-orange-600 underline"
                  >
                    View on Google Maps
                  </a>
                )}
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
};

export default PropertyPage;
