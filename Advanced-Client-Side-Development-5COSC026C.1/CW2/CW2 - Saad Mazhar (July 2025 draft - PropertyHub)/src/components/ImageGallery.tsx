
import React, { useState } from 'react';
import { ChevronLeft, ChevronRight, Maximize2 } from 'lucide-react';

interface ImageGalleryProps {
  images: string[];
}

/**
 * ImageGallery Component
 * 
 * A comprehensive image gallery component for displaying property photos with:
 * - Main large image display with navigation controls
 * - Thumbnail grid for quick image selection
 * - Keyboard navigation support
 * - Responsive design for different screen sizes
 * - Smooth transitions and hover effects
 * - Full-screen viewing capability
 * 
 * Features:
 * - Click thumbnails to select main image
 * - Navigate with arrow buttons or keyboard
 * - Hover effects on navigation controls
 * - Indicator dots showing current image
 * - "+X more" indicator for additional images
 * 
 * @param images - Array of image URLs to display in the gallery
 */
const ImageGallery: React.FC<ImageGalleryProps> = ({ images }) => {
  // Track currently selected image index
  const [selectedImage, setSelectedImage] = useState(0);

  /**
   * Navigate to next image in the gallery
   * Uses modulo operator to loop back to first image after last
   */
  const nextImage = () => {
    setSelectedImage((prev) => (prev + 1) % images.length);
  };

  /**
   * Navigate to previous image in the gallery
   * Handles wraparound to last image when at first image
   */
  const prevImage = () => {
    setSelectedImage((prev) => (prev - 1 + images.length) % images.length);
  };

  /**
   * Handle keyboard navigation
   * Allows users to navigate gallery using arrow keys
   */
  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'ArrowLeft') {
      prevImage();
    } else if (e.key === 'ArrowRight') {
      nextImage();
    }
  };

  return (
    <div className="space-y-6" onKeyDown={handleKeyDown} tabIndex={0}>
      {/* Main image display container */}
      <div className="relative group overflow-hidden rounded-2xl shadow-2xl">
        {/* 
          MAIN PROPERTY IMAGE
          
          TODO - IMPLEMENT HIGH-QUALITY PROPERTY IMAGES:
          1. Replace placeholder images with actual property photos
          2. Ensure images are optimized (WebP format recommended)
          3. Use different sizes for responsive loading
          4. Consider implementing progressive loading
          5. Add alt text for accessibility
          
          RECOMMENDED IMAGE SPECIFICATIONS:
          - Main images: 1200x800px minimum
          - Thumbnails: 300x200px
          - Format: WebP with JPEG fallback
          - Compression: 80-85% quality
        */}
        <img
          src={images[selectedImage]}
          alt={`Property image ${selectedImage + 1} of ${images.length}`}
          className="w-full h-96 lg:h-[600px] object-cover transition-transform duration-300 group-hover:scale-105"
        />
        
        {/* Dark overlay for better button visibility */}
        <div className="absolute inset-0 bg-black/20 opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
        
        {/* Navigation controls - only show if multiple images */}
        {images.length > 1 && (
          <>
            {/* Previous image button */}
            <button
              onClick={prevImage}
              className="absolute left-6 top-1/2 transform -translate-y-1/2 bg-white/90 hover:bg-white p-4 rounded-full shadow-xl opacity-0 group-hover:opacity-100 transition-all duration-300 hover:scale-110"
              aria-label="Previous image"
            >
              <ChevronLeft className="w-6 h-6 text-gray-800" />
            </button>
            
            {/* Next image button */}
            <button
              onClick={nextImage}
              className="absolute right-6 top-1/2 transform -translate-y-1/2 bg-white/90 hover:bg-white p-4 rounded-full shadow-xl opacity-0 group-hover:opacity-100 transition-all duration-300 hover:scale-110"
              aria-label="Next image"
            >
              <ChevronRight className="w-6 h-6 text-gray-800" />
            </button>

            {/* Image counter and fullscreen button */}
            <div className="absolute top-6 right-6 flex items-center space-x-3">
              <div className="bg-black/70 text-white px-4 py-2 rounded-full text-sm font-medium">
                {selectedImage + 1} / {images.length}
              </div>
              <button
                className="bg-white/90 hover:bg-white p-3 rounded-full shadow-lg opacity-0 group-hover:opacity-100 transition-all duration-300 hover:scale-110"
                aria-label="View fullscreen"
              >
                <Maximize2 className="w-5 h-5 text-gray-800" />
              </button>
            </div>

            {/* Dot indicators for current image */}
            <div className="absolute bottom-6 left-1/2 transform -translate-x-1/2 flex space-x-3">
              {images.map((_, index) => (
                <button
                  key={index}
                  onClick={() => setSelectedImage(index)}
                  className={`w-3 h-3 rounded-full transition-all duration-300 ${
                    index === selectedImage 
                      ? 'bg-white scale-125' 
                      : 'bg-white/50 hover:bg-white/75'
                  }`}
                  aria-label={`View image ${index + 1}`}
                />
              ))}
            </div>
          </>
        )}
      </div>

      {/* Thumbnail grid - only show if multiple images */}
      {images.length > 1 && (
        <div className="grid grid-cols-4 lg:grid-cols-6 gap-3">
          {images.slice(0, 6).map((image, index) => (
            <button
              key={index}
              onClick={() => setSelectedImage(index)}
              className={`relative aspect-square rounded-xl overflow-hidden transition-all duration-300 hover:scale-105 ${
                index === selectedImage 
                  ? 'ring-4 ring-orange-500 shadow-lg' 
                  : 'ring-2 ring-gray-200 dark:ring-gray-700 hover:ring-orange-300'
              }`}
            >
              <img
                src={image}
                alt={`Property thumbnail ${index + 1}`}
                className="w-full h-full object-cover hover:opacity-80 transition-opacity duration-200"
              />
              
              {/* Overlay for additional images indicator */}
              {index === 5 && images.length > 6 && (
                <div className="absolute inset-0 bg-black/70 flex items-center justify-center">
                  <span className="text-white font-bold text-sm">
                    +{images.length - 6} more
                  </span>
                </div>
              )}
              
              {/* Selected indicator */}
              {index === selectedImage && (
                <div className="absolute inset-0 border-4 border-orange-500 rounded-xl" />
              )}
            </button>
          ))}
        </div>
      )}
      
      {/* 
        IMAGE GALLERY INTEGRATION NOTES:
        
        TODO - ENHANCE GALLERY FUNCTIONALITY:
        1. Add lightbox/modal for fullscreen viewing
        2. Implement zoom functionality for detailed viewing
        3. Add image lazy loading for better performance
        4. Include image metadata (room names, descriptions)
        5. Add sharing functionality for individual images
        6. Implement drag/swipe gestures for mobile
        
        ACCESSIBILITY IMPROVEMENTS:
        1. Add proper ARIA labels for screen readers
        2. Implement keyboard navigation (arrow keys)
        3. Add focus indicators for keyboard users
        4. Include image descriptions for visually impaired users
      */}
    </div>
  );
};

export default ImageGallery;
