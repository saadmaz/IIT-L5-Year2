
import { Property, SearchFilters } from '@/types/property';

/**
 * Filter properties based on search criteria
 * @param properties - Array of all available properties
 * @param filters - Search filter criteria
 * @returns Filtered array of properties matching all criteria
 */
export const filterProperties = (properties: Property[], filters: SearchFilters): Property[] => {
  return properties.filter(property => {
    // Property type filter - skip if "Any" is selected
    if (filters.type !== 'Any' && property.type !== filters.type) {
      return false;
    }

    // Price range filter - property must be within min/max range
    if (property.price < filters.minPrice || property.price > filters.maxPrice) {
      return false;
    }

    // Bedroom count filter - property must be within min/max range
    if (property.bedrooms < filters.minBedrooms || property.bedrooms > filters.maxBedrooms) {
      return false;
    }

    // Postcode area filter - case-insensitive partial match
    if (filters.postcode && !property.postcode.toLowerCase().includes(filters.postcode.toLowerCase())) {
      return false;
    }

    // Date filter - property must be added after specified date
    if (filters.dateAfter) {
      const propertyDate = new Date(property.added);
      const filterDate = new Date(filters.dateAfter);
      if (propertyDate < filterDate) {
        return false;
      }
    }

    // Property passes all filters
    return true;
  });
};

/**
 * Format price as Sri Lankan currency with thousands separators
 * @param price - Numeric price value
 * @returns Formatted price string (e.g., "Rs. 450,000")
 */
export const formatPrice = (price: number): string => {
  return `Rs. ${price.toLocaleString()}`;
};

/**
 * Format date string to British date format
 * @param dateString - ISO date string
 * @returns Formatted date string (e.g., "15 January 2024")
 */
export const formatDate = (dateString: string): string => {
  const date = new Date(dateString);
  return date.toLocaleDateString('en-GB', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  });
};
