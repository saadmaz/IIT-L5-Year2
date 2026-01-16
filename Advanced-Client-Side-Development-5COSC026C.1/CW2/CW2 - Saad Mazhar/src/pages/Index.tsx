
import { useState, useEffect } from 'react';
import { SearchForm } from '@/components/SearchForm';
import { PropertyGrid } from '@/components/PropertyGrid';
import { FavouritesPanel } from '@/components/FavouritesPanel';
import { Property, SearchFilters } from '@/types/property';
import { filterProperties } from '@/utils/filterUtils';
import propertiesData from '@/data/properties.json';

// Saad Mazhar
// W20532233
// 20221804 

const Index = () => {
  // Initialize properties from JSON data
  const [properties] = useState<Property[]>(propertiesData as Property[]);
  
  // Filtered properties based on search criteria
  const [filteredProperties, setFilteredProperties] = useState<Property[]>(properties);
  
  // Current search filters state
  const [filters, setFilters] = useState<SearchFilters>({
    type: 'Any',
    minPrice: 0,
    maxPrice: 1000000,
    minBedrooms: 1,
    maxBedrooms: 5,
    postcode: '',
    dateAfter: '',
  });

  // Apply filters whenever properties or filters change
  useEffect(() => {
    const filtered = filterProperties(properties, filters);
    setFilteredProperties(filtered);
  }, [properties, filters]);

  // Handle search form submission
  const handleSearch = (newFilters: SearchFilters) => {
    setFilters(newFilters);
  };

  return (
    <div className="min-h-screen bg-background">
      {/* Hero Section - Main landing area with branding */}
      <section className="relative py-12 px-4 gradient-orange text-white">
        <div className="container mx-auto text-center">
          <h1 className="text-4xl md:text-6xl font-bold mb-4">
            Find Your Perfect Home
          </h1>
          <p className="text-xl md:text-2xl text-orange-100 mb-8">
            Discover exceptional properties in Sri Lanka's finest locations
          </p>
        </div>
      </section>

      {/* Search Section - Property filtering form */}
      <section className="py-8 px-4 border-b">
        <div className="container mx-auto">
          <SearchForm onSearch={handleSearch} />
        </div>
      </section>

      {/* Results Section - Property listings and favourites */}
      <section className="py-8 px-4">
        <div className="container mx-auto">
          <div className="flex flex-col lg:flex-row gap-8">
            {/* Main content area - property grid */}
            <main className="flex-1">
              <div className="mb-6">
                <h2 className="text-2xl font-semibold mb-2">
                  {filteredProperties.length} properties found
                </h2>
                <p className="text-muted-foreground">
                  Showing the best properties matching your criteria
                </p>
              </div>
              <PropertyGrid properties={filteredProperties} />
            </main>
            
            {/* Sidebar - favourites panel */}
            <aside className="lg:w-80">
              <FavouritesPanel />
            </aside>
          </div>
        </div>
      </section>
    </div>
  );
};

export default Index;