
import React, { useState, useEffect } from 'react';
import SearchForm from '../components/SearchForm';
import PropertyCard from '../components/PropertyCard';
import FavoritesPanel from '../components/FavoritesPanel';
import Header from '../components/Header';
import propertiesData from '../data/properties.json';
import { Property, SearchFilters } from '../types/Property';

const Index = () => {
  const [properties] = useState<Property[]>(propertiesData);
  const [filteredProperties, setFilteredProperties] = useState<Property[]>(propertiesData);
  const [favorites, setFavorites] = useState<Property[]>([]);
  const [showFavorites, setShowFavorites] = useState(false);

  useEffect(() => {
    const savedFavorites = localStorage.getItem('propertyFavorites');
    if (savedFavorites) {
      setFavorites(JSON.parse(savedFavorites));
    }
  }, []);

  const handleSearch = (filters: SearchFilters) => {
    let filtered = properties;

    if (filters.type && filters.type !== 'Any') {
      filtered = filtered.filter(property => property.type === filters.type);
    }

    if (filters.minPrice) {
      filtered = filtered.filter(property => property.price >= filters.minPrice!);
    }

    if (filters.maxPrice) {
      filtered = filtered.filter(property => property.price <= filters.maxPrice!);
    }

    if (filters.minBedrooms) {
      filtered = filtered.filter(property => property.bedrooms >= filters.minBedrooms!);
    }

    if (filters.maxBedrooms) {
      filtered = filtered.filter(property => property.bedrooms <= filters.maxBedrooms!);
    }

    if (filters.postcodeArea) {
      filtered = filtered.filter(property => 
        property.postcode.toLowerCase().includes(filters.postcodeArea!.toLowerCase())
      );
    }

    if (filters.dateFrom) {
      filtered = filtered.filter(property => 
        new Date(property.added) >= new Date(filters.dateFrom!)
      );
    }

    if (filters.dateTo) {
      filtered = filtered.filter(property => 
        new Date(property.added) <= new Date(filters.dateTo!)
      );
    }

    setFilteredProperties(filtered);
  };

  const handleFavorite = (property: Property) => {
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

  const clearFavorites = () => {
    setFavorites([]);
    localStorage.removeItem('propertyFavorites');
  };

  const isFavorite = (propertyId: number) => {
    return favorites.some(fav => fav.id === propertyId);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-50 to-red-100 dark:from-orange-950/20 dark:to-red-950/20 dark:bg-background">
      <Header />
      
      <div className="container mx-auto px-4 py-8">
        <div className="text-center mb-12">
          <h1 className="text-5xl font-bold text-foreground mb-4">
            Find Your Perfect <span className="text-primary">Home</span>
          </h1>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            Discover exceptional properties across London with our comprehensive search platform
          </p>
        </div>

        <div className="flex flex-col lg:flex-row gap-8">
          <div className="flex-1">
            <SearchForm onSearch={handleSearch} />
            
            <div className="mt-8">
              <div className="flex justify-between items-center mb-6">
                <h2 className="text-2xl font-semibold text-foreground">
                  {filteredProperties.length} Properties Found
                </h2>
                <button
                  onClick={() => setShowFavorites(!showFavorites)}
                  className="lg:hidden bg-primary text-primary-foreground px-4 py-2 rounded-lg hover:bg-primary/90 transition-colors"
                >
                  {showFavorites ? 'Hide' : 'Show'} Favorites ({favorites.length})
                </button>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {filteredProperties.map(property => (
                  <PropertyCard
                    key={property.id}
                    property={property}
                    isFavorite={isFavorite(property.id)}
                    onFavorite={handleFavorite}
                  />
                ))}
              </div>

              {filteredProperties.length === 0 && (
                <div className="text-center py-12">
                  <p className="text-xl text-muted-foreground">No properties match your search criteria.</p>
                  <p className="text-muted-foreground mt-2">Try adjusting your filters to see more results.</p>
                </div>
              )}
            </div>
          </div>

          <div className={`lg:block ${showFavorites ? 'block' : 'hidden'} lg:w-80`}>
            <FavoritesPanel
              favorites={favorites}
              onRemoveFavorite={handleFavorite}
              onClearAll={clearFavorites}
            />
          </div>
        </div>
      </div>
    </div>
  );
};

export default Index;
