
export interface Property {
  id: number;
  type: string;
  bedrooms: number;
  price: number;
  location: string;
  description: string;
  added: string;
  picture: string;
  images: string[];
  url: string;
  tenure: string;
  postcode: string;
}

export interface SearchFilters {
  type?: string;
  minPrice?: number;
  maxPrice?: number;
  minBedrooms?: number;
  maxBedrooms?: number;
  postcodeArea?: string;
  dateFrom?: string;
  dateTo?: string;
}
