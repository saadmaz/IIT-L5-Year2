
import { PropertyCard } from './PropertyCard';
import { Property } from '@/types/property';

/**
 * Props interface for PropertyGrid component
 */
interface PropertyGridProps {
  properties: Property[]; // Array of properties to display in grid layout
}

/**
 * Property Grid Component
 * Displays a responsive grid of property cards with empty state handling
 * 
 * Features:
 * - Responsive CSS Grid layout (1-3 columns based on screen size)
 * - Empty state message when no properties found
 * - Consistent spacing and alignment
 * - Automatic grid item sizing
 * 
 * Layout Breakpoints:
 * - Mobile: 1 column
 * - Tablet: 2 columns
 * - Desktop: 3 columns
 * 
 * @param properties - Array of Property objects to render as cards
 */
export const PropertyGrid: React.FC<PropertyGridProps> = ({ properties }) => {
  // Handle empty state - show helpful message when no properties available
  if (properties.length === 0) {
    return (
      <div className="text-center py-12">
        <h3 className="text-xl font-semibold mb-2">No properties found</h3>
        <p className="text-muted-foreground">Try adjusting your search criteria</p>
      </div>
    );
  }

  // Render responsive grid of property cards
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {properties.map((property) => (
        <PropertyCard key={property.id} property={property} />
      ))}
    </div>
  );
};
