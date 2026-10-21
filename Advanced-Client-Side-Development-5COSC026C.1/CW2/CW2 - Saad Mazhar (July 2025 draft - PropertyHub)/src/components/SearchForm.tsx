
import React, { useState } from 'react';
import { Search, Filter } from 'lucide-react';
import { SearchFilters } from '../types/Property';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Card, CardContent } from '@/components/ui/card';

interface SearchFormProps {
  onSearch: (filters: SearchFilters) => void;
}

/**
 * SearchForm Component
 * 
 * This component renders a comprehensive property search form with multiple filter options.
 * It supports filtering by property type, price range, bedrooms, postcode area, and date range.
 * 
 * Features:
 * - Responsive design that adapts to different screen sizes
 * - Advanced filters that can be toggled on/off
 * - Real-time form state management
 * - Elegant styling with hover effects and smooth transitions
 * 
 * @param onSearch - Callback function that receives the current filter state
 */
const SearchForm: React.FC<SearchFormProps> = ({ onSearch }) => {
  // State management for all filter options
  const [filters, setFilters] = useState<SearchFilters>({});
  const [showAdvanced, setShowAdvanced] = useState(false);

  /**
   * Handle form submission
   * Prevents default form behavior and triggers the search with current filters
   */
  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSearch(filters);
  };

  /**
   * Generic filter change handler
   * Updates the filters state with new values and removes empty/undefined values
   * 
   * @param key - The filter key to update
   * @param value - The new value for the filter
   */
  const handleFilterChange = (key: keyof SearchFilters, value: string | number) => {
    setFilters(prev => ({
      ...prev,
      [key]: value || undefined
    }));
  };

  return (
    <Card className="shadow-2xl border-0 bg-gradient-to-br from-white to-orange-50 dark:from-gray-900 dark:to-gray-800">
      <CardContent className="p-8">
        <form onSubmit={handleSubmit} className="space-y-8">
          {/* Primary search filters - always visible */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {/* Property Type Selector */}
            <div className="space-y-2">
              <label className="block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-3">
                Property Type
              </label>
              <Select onValueChange={(value) => handleFilterChange('type', value)}>
                <SelectTrigger className="h-12 border-2 border-orange-200 dark:border-orange-800 focus:border-orange-400 transition-colors">
                  <SelectValue placeholder="Any Type" />
                </SelectTrigger>
                <SelectContent className="bg-white dark:bg-gray-800 border-orange-200 dark:border-orange-700">
                  <SelectItem value="Any">Any Type</SelectItem>
                  <SelectItem value="House">House</SelectItem>
                  <SelectItem value="Flat">Flat</SelectItem>
                </SelectContent>
              </Select>
            </div>

            {/* Minimum Price Input */}
            <div className="space-y-2">
              <label className="block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-3">
                Min Price (£)
              </label>
              <Input
                type="number"
                placeholder="No minimum"
                className="h-12 border-2 border-orange-200 dark:border-orange-800 focus:border-orange-400 transition-colors"
                onChange={(e) => handleFilterChange('minPrice', parseInt(e.target.value))}
              />
            </div>

            {/* Maximum Price Input */}
            <div className="space-y-2">
              <label className="block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-3">
                Max Price (£)
              </label>
              <Input
                type="number"
                placeholder="No maximum"
                className="h-12 border-2 border-orange-200 dark:border-orange-800 focus:border-orange-400 transition-colors"
                onChange={(e) => handleFilterChange('maxPrice', parseInt(e.target.value))}
              />
            </div>

            {/* Postcode Area Search */}
            <div className="space-y-2">
              <label className="block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-3">
                Postcode Area
              </label>
              <Input
                type="text"
                placeholder="e.g. SW1, NW1, BR1"
                className="h-12 border-2 border-orange-200 dark:border-orange-800 focus:border-orange-400 transition-colors"
                onChange={(e) => handleFilterChange('postcodeArea', e.target.value)}
              />
            </div>
          </div>

          {/* Action buttons row */}
          <div className="flex flex-col sm:flex-row justify-between items-center gap-4 pt-4">
            {/* Advanced filters toggle button */}
            <Button
              type="button"
              variant="outline"
              onClick={() => setShowAdvanced(!showAdvanced)}
              className="flex items-center space-x-2 border-2 border-orange-300 text-orange-700 hover:bg-orange-50 dark:border-orange-600 dark:text-orange-300 dark:hover:bg-orange-900/20 transition-all duration-200"
            >
              <Filter className="w-4 h-4" />
              <span>{showAdvanced ? 'Hide' : 'Show'} Advanced Filters</span>
            </Button>

            {/* Main search button with gradient styling */}
            <Button 
              type="submit" 
              className="flex items-center space-x-2 bg-gradient-to-r from-orange-500 to-red-500 hover:from-orange-600 hover:to-red-600 text-white px-8 py-3 rounded-lg shadow-lg hover:shadow-xl transition-all duration-200 transform hover:scale-105"
            >
              <Search className="w-5 h-5" />
              <span>Search Properties</span>
            </Button>
          </div>

          {/* Advanced filters section - conditionally rendered */}
          {showAdvanced && (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 pt-6 border-t-2 border-orange-200 dark:border-orange-800 animate-fade-in">
              {/* Minimum Bedrooms Filter */}
              <div className="space-y-2">
                <label className="block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-3">
                  Min Bedrooms
                </label>
                <Select onValueChange={(value) => handleFilterChange('minBedrooms', parseInt(value))}>
                  <SelectTrigger className="h-12 border-2 border-orange-200 dark:border-orange-800 focus:border-orange-400 transition-colors">
                    <SelectValue placeholder="Any" />
                  </SelectTrigger>
                  <SelectContent className="bg-white dark:bg-gray-800 border-orange-200 dark:border-orange-700">
                    <SelectItem value="1">1+ bedrooms</SelectItem>
                    <SelectItem value="2">2+ bedrooms</SelectItem>
                    <SelectItem value="3">3+ bedrooms</SelectItem>
                    <SelectItem value="4">4+ bedrooms</SelectItem>
                    <SelectItem value="5">5+ bedrooms</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              {/* Maximum Bedrooms Filter */}
              <div className="space-y-2">
                <label className="block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-3">
                  Max Bedrooms
                </label>
                <Select onValueChange={(value) => handleFilterChange('maxBedrooms', parseInt(value))}>
                  <SelectTrigger className="h-12 border-2 border-orange-200 dark:border-orange-800 focus:border-orange-400 transition-colors">
                    <SelectValue placeholder="Any" />
                  </SelectTrigger>
                  <SelectContent className="bg-white dark:bg-gray-800 border-orange-200 dark:border-orange-700">
                    <SelectItem value="1">1 bedroom</SelectItem>
                    <SelectItem value="2">2 bedrooms</SelectItem>
                    <SelectItem value="3">3 bedrooms</SelectItem>
                    <SelectItem value="4">4 bedrooms</SelectItem>
                    <SelectItem value="5">5+ bedrooms</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              {/* Date From Filter */}
              <div className="space-y-2">
                <label className="block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-3">
                  Added From
                </label>
                <Input
                  type="date"
                  className="h-12 border-2 border-orange-200 dark:border-orange-800 focus:border-orange-400 transition-colors"
                  onChange={(e) => handleFilterChange('dateFrom', e.target.value)}
                />
              </div>

              {/* Date To Filter */}
              <div className="space-y-2">
                <label className="block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-3">
                  Added To
                </label>
                <Input
                  type="date"
                  className="h-12 border-2 border-orange-200 dark:border-orange-800 focus:border-orange-400 transition-colors"
                  onChange={(e) => handleFilterChange('dateTo', e.target.value)}
                />
              </div>
            </div>
          )}
        </form>
      </CardContent>
    </Card>
  );
};

export default SearchForm;
