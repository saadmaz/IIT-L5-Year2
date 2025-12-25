
import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Search } from 'lucide-react';
import { SearchFilters } from '@/types/property';

interface SearchFormProps {
  onSearch: (filters: SearchFilters) => void;
}

export const SearchForm: React.FC<SearchFormProps> = ({ onSearch }) => {
  // Local state for form filters - initialized with default values
  const [filters, setFilters] = useState<SearchFilters>({
    type: 'Any',
    minPrice: 0,
    maxPrice: 1000000,
    minBedrooms: 1,
    maxBedrooms: 5,
    postcode: '',
    dateAfter: '',
  });

  // Handle form submission and trigger parent search
  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSearch(filters);
  };

  // Generic filter update helper function
  const updateFilter = (key: keyof SearchFilters, value: string | number) => {
    setFilters(prev => ({ ...prev, [key]: value }));
  };

  return (
    <Card className="shadow-orange">
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Search className="h-5 w-5 text-orange-500" />
          Search Properties
        </CardTitle>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-6">
          {/* Primary filters row - most commonly used filters */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            {/* Property Type Filter */}
            <div className="space-y-2">
              <Label htmlFor="type">Property Type</Label>
              <Select value={filters.type} onValueChange={(value) => updateFilter('type', value)}>
                <SelectTrigger>
                  <SelectValue placeholder="Select type" />
                </SelectTrigger>
                <SelectContent className="bg-popover">
                  <SelectItem value="Any">Any</SelectItem>
                  <SelectItem value="House">House</SelectItem>
                  <SelectItem value="Flat">Flat</SelectItem>
                </SelectContent>
              </Select>
            </div>

            {/* Price Range Filters */}
            <div className="space-y-2">
              <Label htmlFor="minPrice">Min Price</Label>
              <Input
                id="minPrice"
                type="number"
                value={filters.minPrice}
                onChange={(e) => updateFilter('minPrice', parseInt(e.target.value) || 0)}
                placeholder="Rs. 0"
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="maxPrice">Max Price</Label>
              <Input
                id="maxPrice"
                type="number"
                value={filters.maxPrice}
                onChange={(e) => updateFilter('maxPrice', parseInt(e.target.value) || 1000000)}
                placeholder="Rs.1,000,000"
              />
            </div>

            {/* Location Filter */}
            <div className="space-y-2">
              <Label htmlFor="postcode">Postcode Area</Label>
              <Input
                id="postcode"
                value={filters.postcode}
                onChange={(e) => updateFilter('postcode', e.target.value)}
                placeholder="e.g. 10350"
              />
            </div>
          </div>

          {/* Secondary filters row - bedroom count and date filters */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {/* Bedroom Range Filters */}
            <div className="space-y-2">
              <Label htmlFor="minBedrooms">Min Bedrooms</Label>
              <Select value={filters.minBedrooms.toString()} onValueChange={(value) => updateFilter('minBedrooms', parseInt(value))}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent className="bg-popover">
                  {[1, 2, 3, 4, 5].map(num => (
                    <SelectItem key={num} value={num.toString()}>{num}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="maxBedrooms">Max Bedrooms</Label>
              <Select value={filters.maxBedrooms.toString()} onValueChange={(value) => updateFilter('maxBedrooms', parseInt(value))}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent className="bg-popover">
                  {[1, 2, 3, 4, 5].map(num => (
                    <SelectItem key={num} value={num.toString()}>{num}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            {/* Date Filter */}
            <div className="space-y-2">
              <Label htmlFor="dateAfter">Added After</Label>
              <Input
                id="dateAfter"
                type="date"
                value={filters.dateAfter}
                onChange={(e) => updateFilter('dateAfter', e.target.value)}
              />
            </div>
          </div>

          {/* Search Submit Button */}
          <Button type="submit" className="w-full gradient-orange hover:from-orange-500 hover:to-orange-700 text-white">
            <Search className="h-4 w-4 mr-2" />
            Search Properties
          </Button>
        </form>
      </CardContent>
    </Card>
  );
};
