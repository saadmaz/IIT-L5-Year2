
import { useState } from 'react';
import { ChevronLeft, ChevronRight, Home } from 'lucide-react';
import { Button } from '@/components/ui/button';

/**
 * Props interface for ImageGallery component
 */
interface ImageGalleryProps {
  images: string[]; // Array of image URLs to display in gallery
}

/**
 * Image Gallery Component
 * Displays a carousel-style image viewer with thumbnail navigation
 * 
 * Features:
 * - Large main image display with aspect ratio preservation
 * - Previous/Next navigation buttons
 * - Thumbnail grid for direct image selection
 * - Image loading error handling with placeholder fallback
 * - Current image indicator (X / Total)
 * - Responsive thumbnail grid layout
 * - Active thumbnail highlighting
 * - Smooth transitions and hover effects
 * 
 * @param images - Array of image URLs to display
 */
export const ImageGallery: React.FC<ImageGalleryProps> = ({ images }) => {
  // State for tracking current displayed image index
  const [currentImage, setCurrentImage] = useState(0);
  // State for tracking which images failed to load (for fallback display)
  const [imageErrors, setImageErrors] = useState<{ [key: number]: boolean }>({});

  /**
   * Navigate to next image in sequence
   * Wraps around to first image when reaching the end
   */
  const nextImage = () => {
    setCurrentImage((prev) => (prev + 1) % images.length);
  };

  /**
   * Navigate to previous image in sequence  
   * Wraps around to last image when at the beginning
   */
  const prevImage = () => {
    setCurrentImage((prev) => (prev - 1 + images.length) % images.length);
  };

  /**
   * Handle image loading errors by marking image as failed
   * This triggers fallback placeholder display
   * 
   * @param index - Index of the image that failed to load
   */
  const handleImageError = (index: number) => {
    setImageErrors(prev => ({ ...prev, [index]: true }));
  };

  /**
   * Placeholder component for failed image loads
   * Shows a home icon on orange gradient background
   */
  const PlaceholderImage = () => (
    <div className="w-full h-full bg-gradient-to-br from-orange-100 to-orange-200 flex items-center justify-center">
      <Home className="h-16 w-16 text-orange-400" />
    </div>
  );

  return (
    <div className="space-y-4">
      {/* Main Image Display Area */}
      <div className="relative aspect-video rounded-lg overflow-hidden bg-muted">
        {/* Main Image or Placeholder */}
        {imageErrors[currentImage] ? (
          <PlaceholderImage />
        ) : (
          <img
            src={images[currentImage]}
            alt={`Property image ${currentImage + 1}`}
            className="w-full h-full object-cover"
            onError={() => handleImageError(currentImage)}
          />
        )}
        
        {/* Navigation Buttons - Only show if multiple images */}
        {images.length > 1 && (
          <>
            {/* Previous Image Button */}
            <Button
              variant="ghost"
              size="sm"
              className="absolute left-2 top-1/2 -translate-y-1/2 bg-white/90 hover:bg-white shadow-md"
              onClick={prevImage}
            >
              <ChevronLeft className="h-4 w-4" />
            </Button>
            
            {/* Next Image Button */}
            <Button
              variant="ghost"
              size="sm"
              className="absolute right-2 top-1/2 -translate-y-1/2 bg-white/90 hover:bg-white shadow-md"
              onClick={nextImage}
            >
              <ChevronRight className="h-4 w-4" />
            </Button>
          </>
        )}
        
        {/* Image Counter - Shows current position in gallery */}
        <div className="absolute bottom-2 right-2 bg-black/70 text-white px-2 py-1 rounded text-sm">
          {currentImage + 1} / {images.length}
        </div>
      </div>

      {/* Thumbnail Navigation Grid - Only show if multiple images */}
      {images.length > 1 && (
        <div className="grid grid-cols-4 md:grid-cols-6 lg:grid-cols-8 gap-2">
          {images.map((image, index) => (
            <button
              key={index}
              className={`aspect-square rounded-lg overflow-hidden border-2 transition-colors ${
                index === currentImage 
                  ? 'border-orange-500'      // Active thumbnail - orange border
                  : 'border-transparent hover:border-orange-300' // Inactive - transparent with hover
              }`}
              onClick={() => setCurrentImage(index)}
            >
              {/* Thumbnail Image or Placeholder */}
              {imageErrors[index] ? (
                <div className="w-full h-full bg-gradient-to-br from-orange-100 to-orange-200 flex items-center justify-center">
                  <Home className="h-4 w-4 text-orange-400" />
                </div>
              ) : (
                <img
                  src={image}
                  alt={`Thumbnail ${index + 1}`}
                  className="w-full h-full object-cover"
                  onError={() => handleImageError(index)}
                />
              )}
            </button>
          ))}
        </div>
      )}
    </div>
  );
};
