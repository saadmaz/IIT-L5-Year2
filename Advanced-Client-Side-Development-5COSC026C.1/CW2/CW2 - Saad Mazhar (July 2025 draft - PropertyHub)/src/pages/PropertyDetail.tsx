
import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { ArrowLeft, Heart, MapPin, Bed, Calendar, Home, Phone, Mail, Share2 } from 'lucide-react';
import { Property } from '../types/Property';
import propertiesData from '../data/properties.json';
import ImageGallery from '../components/ImageGallery';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Button } from '@/components/ui/button';

/**
 * PropertyDetail Component
 * 
 * This is the main property detail view that displays comprehensive information about a single property.
 * It includes:
 * - Property image gallery
 * - Detailed property information
 * - Interactive tabs for different content sections
 * - Favorite functionality
 * - Contact options
 * - Responsive design for all screen sizes
 * 
 * The component fetches property data based on the URL parameter and manages favorites in localStorage.
 */
const PropertyDetail = () => {
  // Extract property ID from URL parameters
  const { id } = useParams<{ id: string }>();
  
  // Component state management
  const [property, setProperty] = useState<Property | null>(null);
  const [favorites, setFavorites] = useState<Property[]>([]);
  const [loading, setLoading] = useState(true);

  /**
   * Load property data and favorites on component mount
   * This effect runs when the component mounts or when the ID parameter changes
   */
  useEffect(() => {
    const propertyId = parseInt(id || '0');
    const foundProperty = propertiesData.find(p => p.id === propertyId);
    setProperty(foundProperty || null);
    setLoading(false);

    // Load favorites from localStorage
    const savedFavorites = localStorage.getItem('propertyFavorites');
    if (savedFavorites) {
      setFavorites(JSON.parse(savedFavorites));
    }
  }, [id]);

  /**
   * Handle favorite button functionality
   * Toggles the property in/out of favorites and updates localStorage
   */
  const handleFavorite = () => {
    if (!property) return;

    const isAlreadyFavorite = favorites.some(fav => fav.id === property.id);
    let newFavorites;

    if (isAlreadyFavorite) {
      newFavorites = favorites.filter(fav => fav.id !== property.id);
    } else {
      newFavorites = [...favorites, property];
    }

    setFavorites(newFavorites);
    localStorage.setItem('propertyFavorites', JSON.stringify(newFavorites));
  };

  /**
   * Handle property sharing functionality
   * TODO: Implement actual sharing logic with Web Share API or custom modal
   */
  const handleShare = () => {
    // TODO: Implement sharing functionality
    console.log('Share property:', property?.id);
  };

  // Check if current property is in favorites
  const isFavorite = property ? favorites.some(fav => fav.id === property.id) : false;

  // Loading state
  if (loading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-primary"></div>
      </div>
    );
  }

  // Property not found state
  if (!property) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center space-y-4">
          <h1 className="text-3xl font-bold text-foreground">Property Not Found</h1>
          <p className="text-muted-foreground">The property you're looking for doesn't exist or has been removed.</p>
          <Link to="/" className="inline-flex items-center text-primary hover:text-primary/80 font-semibold">
            <ArrowLeft className="w-4 h-4 mr-2" />
            Return to Search
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-50 to-red-100 dark:from-orange-950/20 dark:to-red-950/20 dark:bg-background">
      {/* Navigation header */}
      <div className="bg-card/80 backdrop-blur-sm shadow-sm border-b border-border sticky top-0 z-10">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <Link 
              to="/" 
              className="inline-flex items-center text-primary hover:text-primary/80 font-semibold transition-colors"
            >
              <ArrowLeft className="w-5 h-5 mr-2" />
              Back to Search
            </Link>
            
            {/* Action buttons */}
            <div className="flex items-center space-x-3">
              <Button
                variant="outline"
                size="sm"
                onClick={handleShare}
                className="border-orange-300 text-orange-700 hover:bg-orange-50 dark:border-orange-600 dark:text-orange-300"
              >
                <Share2 className="w-4 h-4 mr-2" />
                Share
              </Button>
            </div>
          </div>
        </div>
      </div>

      <div className="container mx-auto px-4 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Left column - Image gallery and main content */}
          <div className="lg:col-span-2 space-y-8">
            {/* Property image gallery */}
            <ImageGallery images={property.images} />
            
            {/* Property title and basic info */}
            <div className="bg-card rounded-2xl shadow-lg p-6 border border-border">
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center space-x-3">
                  <div className="bg-primary/10 p-3 rounded-lg">
                    <Home className="w-6 h-6 text-primary" />
                  </div>
                  <div>
                    <h1 className="text-2xl font-bold text-foreground">{property.type}</h1>
                    <p className="text-muted-foreground">{property.location}</p>
                  </div>
                </div>
                
                <div className="text-right">
                  <div className="text-3xl font-bold text-primary">
                    £{property.price.toLocaleString()}
                  </div>
                  <div className="text-sm text-muted-foreground">
                    {property.tenure}
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Right column - Property details and contact */}
          <div className="lg:col-span-1">
            <div className="bg-card rounded-2xl shadow-xl p-8 sticky top-24 border border-border">
              {/* Price and favorite section */}
              <div className="flex justify-between items-start mb-6">
                <div>
                  <h2 className="text-4xl font-bold text-foreground mb-2">
                    £{property.price.toLocaleString()}
                  </h2>
                  <div className="flex items-center text-muted-foreground">
                    <MapPin className="w-4 h-4 mr-1" />
                    {property.location}
                  </div>
                </div>
                <button
                  onClick={handleFavorite}
                  className={`p-4 rounded-full transition-all duration-300 transform hover:scale-110 ${
                    isFavorite 
                      ? 'bg-red-100 dark:bg-red-900/20 text-red-600 shadow-lg' 
                      : 'bg-muted text-muted-foreground hover:bg-red-100 dark:hover:bg-red-900/20 hover:text-red-600 shadow-md'
                  }`}
                  aria-label={isFavorite ? 'Remove from favorites' : 'Add to favorites'}
                >
                  <Heart className={`w-7 h-7 ${isFavorite ? 'fill-current' : ''}`} />
                </button>
              </div>

              {/* Property stats grid */}
              <div className="grid grid-cols-2 gap-4 mb-8">
                <div className="bg-blue-50 dark:bg-blue-900/20 p-6 rounded-xl text-center">
                  <Bed className="w-8 h-8 mx-auto mb-3 text-blue-500" />
                  <p className="text-sm text-muted-foreground mb-1">Bedrooms</p>
                  <p className="text-2xl font-bold text-foreground">{property.bedrooms}</p>
                </div>
                <div className="bg-green-50 dark:bg-green-900/20 p-6 rounded-xl text-center">
                  <Calendar className="w-8 h-8 mx-auto mb-3 text-green-500" />
                  <p className="text-sm text-muted-foreground mb-1">Added</p>
                  <p className="text-lg font-bold text-foreground">
                    {new Date(property.added).toLocaleDateString('en-GB', {
                      day: 'numeric',
                      month: 'short'
                    })}
                  </p>
                </div>
              </div>

              {/* Property details list */}
              <div className="space-y-4 mb-8">
                <div className="flex justify-between py-3 border-b border-border">
                  <span className="text-muted-foreground font-medium">Property Type:</span>
                  <span className="font-semibold text-foreground">{property.type}</span>
                </div>
                <div className="flex justify-between py-3 border-b border-border">
                  <span className="text-muted-foreground font-medium">Tenure:</span>
                  <span className="font-semibold text-foreground">{property.tenure}</span>
                </div>
                <div className="flex justify-between py-3 border-b border-border">
                  <span className="text-muted-foreground font-medium">Postcode:</span>
                  <span className="font-semibold text-foreground">{property.postcode}</span>
                </div>
              </div>

              {/* Contact buttons */}
              <div className="space-y-3">
                <Button className="w-full bg-gradient-to-r from-orange-500 to-red-500 hover:from-orange-600 hover:to-red-600 text-white py-4 rounded-xl shadow-lg hover:shadow-xl transition-all duration-200">
                  <Phone className="w-5 h-5 mr-2" />
                  Call Agent
                </Button>
                <Button 
                  variant="outline" 
                  className="w-full border-2 border-orange-300 text-orange-700 hover:bg-orange-50 dark:border-orange-600 dark:text-orange-300 py-4 rounded-xl"
                >
                  <Mail className="w-5 h-5 mr-2" />
                  Email Enquiry
                </Button>
              </div>
            </div>
          </div>
        </div>

        {/* Tabbed content section */}
        <div className="mt-16">
          <Tabs defaultValue="description" className="w-full">
            <TabsList className="grid w-full grid-cols-3 bg-card border border-border rounded-xl p-2">
              <TabsTrigger 
                value="description" 
                className="rounded-lg data-[state=active]:bg-primary data-[state=active]:text-primary-foreground"
              >
                Description
              </TabsTrigger>
              <TabsTrigger 
                value="floorplan" 
                className="rounded-lg data-[state=active]:bg-primary data-[state=active]:text-primary-foreground"
              >
                Floor Plan
              </TabsTrigger>
              <TabsTrigger 
                value="location" 
                className="rounded-lg data-[state=active]:bg-primary data-[state=active]:text-primary-foreground"
              >
                Location
              </TabsTrigger>
            </TabsList>
            
            {/* Description tab content */}
            <TabsContent value="description" className="mt-8">
              <div className="bg-card rounded-2xl shadow-xl p-10 border border-border">
                <h3 className="text-3xl font-bold text-foreground mb-6">Property Description</h3>
                <div className="prose prose-lg max-w-none text-muted-foreground">
                  <p className="leading-relaxed text-lg">{property.description}</p>
                </div>
              </div>
            </TabsContent>
            
            {/* Floor plan tab content */}
            <TabsContent value="floorplan" className="mt-8">
              <div className="bg-card rounded-2xl shadow-xl p-10 border border-border">
                <h3 className="text-3xl font-bold text-foreground mb-6">Floor Plan</h3>
                {/* 
                  FLOOR PLAN INTEGRATION
                  
                  TODO - IMPLEMENT FLOOR PLAN FUNCTIONALITY:
                  1. Add floor plan images to your assets
                  2. Create a floor plan viewer component
                  3. Support multiple floor levels if applicable
                  4. Add zoom and pan functionality
                  5. Include room labels and measurements
                  
                  RECOMMENDED IMPLEMENTATION:
                  - Store floor plan images in public/floorplans/
                  - Create FloorPlanViewer component with zoom controls
                  - Add floor plan URLs to property data
                  - Support interactive hotspots for room details
                */}
                <div className="bg-muted h-96 rounded-xl flex items-center justify-center border-2 border-dashed border-muted-foreground/30">
                  <div className="text-center">
                    <Home className="w-16 h-16 mx-auto mb-4 text-muted-foreground/50" />
                    <p className="text-muted-foreground text-lg font-medium">Floor plan would be displayed here</p>
                    <p className="text-muted-foreground/70 text-sm mt-2">
                      Implement floor plan viewer component
                    </p>
                  </div>
                </div>
              </div>
            </TabsContent>
            
            {/* Location tab content */}
            <TabsContent value="location" className="mt-8">
              <div className="bg-card rounded-2xl shadow-xl p-10 border border-border">
                <h3 className="text-3xl font-bold text-foreground mb-6">Location & Map</h3>
                {/* 
                  GOOGLE MAPS INTEGRATION
                  
                  TODO - IMPLEMENT GOOGLE MAPS:
                  1. Get Google Maps API key from Google Cloud Console
                  2. Install @googlemaps/js-api-loader package
                  3. Create GoogleMap component with property location
                  4. Add nearby amenities markers (schools, transport, shops)
                  5. Include street view integration
                  
                  IMPLEMENTATION STEPS:
                  ```bash
                  npm install @googlemaps/js-api-loader
                  ```
                  
                  COMPONENT STRUCTURE:
                  - GoogleMap component with lat/lng props
                  - Property marker with custom icon
                  - Nearby amenities layer
                  - Transit information overlay
                  - Walking score integration
                  
                  EXAMPLE USAGE:
                  <GoogleMap 
                    latitude={property.coordinates.lat} 
                    longitude={property.coordinates.lng}
                    zoom={15}
                    showNearbyAmenities={true}
                  />
                */}
                <div className="bg-muted h-96 rounded-xl flex items-center justify-center border-2 border-dashed border-muted-foreground/30">
                  <div className="text-center">
                    <MapPin className="w-16 h-16 mx-auto mb-4 text-muted-foreground/50" />
                    <p className="text-muted-foreground text-lg font-medium">Google Maps integration would be here</p>
                    <p className="text-muted-foreground/70 text-sm mt-2">
                      Install Google Maps API and implement GoogleMap component
                    </p>
                    <div className="mt-4 text-left bg-gray-100 dark:bg-gray-800 p-4 rounded-lg text-sm">
                      <p className="font-semibold mb-2">Integration Steps:</p>
                      <ol className="list-decimal list-inside space-y-1 text-muted-foreground">
                        <li>Get Google Maps API key</li>
                        <li>Install @googlemaps/js-api-loader</li>
                        <li>Create GoogleMap component</li>
                        <li>Add property coordinates to data</li>
                        <li>Implement nearby amenities</li>
                      </ol>
                    </div>
                  </div>
                </div>
              </div>
            </TabsContent>
          </Tabs>
        </div>
      </div>
    </div>
  );
};

export default PropertyDetail;
