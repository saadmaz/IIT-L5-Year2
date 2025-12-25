
// Property data structure matching our JSON properties
export interface Property {
  id: number;
  type: 'House' | 'Flat';
  bedrooms: number;
  price: number;
  location: string;
  postcode: string;
  description: string;
  added: string;
  picture: string;
  url: string;
  tenure: 'Freehold' | 'Leasehold';
  images: string[];
}

// Search filters for property filtering functionality
export interface SearchFilters {
  type: string;
  minPrice: number;
  maxPrice: number;
  minBedrooms: number;
  maxBedrooms: number;
  postcode: string;
  dateAfter: string;
}
