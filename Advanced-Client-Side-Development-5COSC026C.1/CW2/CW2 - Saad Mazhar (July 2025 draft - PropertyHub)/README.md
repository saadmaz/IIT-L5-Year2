
# PropertyHub - React Property Search Application

A modern, responsive property search application inspired by Rightmove, built with React, TypeScript, and Tailwind CSS.

## 🏡 Features

### Core Functionality
- **Advanced Property Search** - Filter by type, price range, bedrooms, postcode, and date added
- **Interactive Property Cards** - Hover effects, favorite buttons, and detailed property information
- **Comprehensive Property Details** - Image galleries, tabbed content, and contact options
- **Favorites Management** - Save properties with drag-and-drop and persistent localStorage
- **Responsive Design** - Optimized for desktop, tablet, and mobile devices
- **Dark/Light Theme** - Toggle between themes with system preference detection

### Technical Features
- **Type-Safe Development** - Full TypeScript implementation
- **Modern UI Components** - Shadcn/ui component library
- **Smooth Animations** - Framer Motion and CSS transitions
- **Accessible Design** - ARIA labels and keyboard navigation
- **Performance Optimized** - Lazy loading and efficient state management

## 📁 Project Structure

```
PropertyHub/
├── src/
│   ├── components/           # Reusable UI components
│   │   ├── Header.tsx       # Main navigation header
│   │   ├── SearchForm.tsx   # Advanced property search form
│   │   ├── PropertyCard.tsx # Individual property display cards
│   │   ├── FavoritesPanel.tsx # Favorites management sidebar
│   │   ├── ImageGallery.tsx # Property image carousel
│   │   ├── ThemeToggle.tsx  # Dark/light theme switcher
│   │   └── ui/             # Shadcn/ui components
│   ├── pages/              # Main application pages
│   │   ├── Index.tsx       # Home page with search and results
│   │   ├── PropertyDetail.tsx # Individual property details
│   │   └── NotFound.tsx    # 404 error page
│   ├── types/              # TypeScript type definitions
│   │   └── Property.ts     # Property data interface
│   ├── data/               # Static data files
│   │   └── properties.json # Sample property dataset
│   ├── hooks/              # Custom React hooks
│   ├── lib/                # Utility functions
│   └── styles/             # Global CSS and theme
├── public/                 # Static assets
└── docs/                   # Documentation
```

## 🚀 Getting Started

### Prerequisites
- Node.js 18+ 
- npm or yarn package manager

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/propertyhub.git
   cd propertyhub
   ```

2. **Install dependencies**
   ```bash
   npm install
   # or
   yarn install
   ```

3. **Start development server**
   ```bash
   npm run dev
   # or
   yarn dev
   ```

4. **Open in browser**
   Navigate to `http://localhost:5173`

## 🎨 Customization

### Theme Configuration
The application uses a custom orange-themed design system. Colors can be modified in:
- `src/index.css` - CSS custom properties for light/dark themes
- `tailwind.config.ts` - Tailwind CSS color palette

### Adding Properties
Extend the property dataset by modifying `src/data/properties.json`:

```json
{
  "id": 8,
  "type": "House",
  "bedrooms": 4,
  "price": 750000,
  "location": "Richmond, Surrey",
  "description": "Beautiful Victorian house...",
  "added": "2024-01-15",
  "picture": "https://images.unsplash.com/...",
  "images": ["image1.jpg", "image2.jpg"],
  "url": "property-url",
  "tenure": "Freehold",
  "postcode": "TW9"
}
```

## 🔧 Integration Guidelines

### Adding Property Images

**Recommended Implementation:**
```typescript
// Store images in public/images/properties/
const propertyImages = [
  '/images/properties/house-1-main.jpg',
  '/images/properties/house-1-kitchen.jpg',
  '/images/properties/house-1-bedroom.jpg'
];

// Image specifications:
// - Main images: 1200x800px minimum
// - Thumbnails: 300x200px  
// - Format: WebP with JPEG fallback
// - Compression: 80-85% quality
```

### Google Maps Integration

**Installation:**
```bash
npm install @googlemaps/js-api-loader
```

**Implementation:**
```typescript
// components/GoogleMap.tsx
import { Loader } from '@googlemaps/js-api-loader';

const GoogleMap = ({ latitude, longitude }) => {
  useEffect(() => {
    const loader = new Loader({
      apiKey: 'YOUR_GOOGLE_MAPS_API_KEY',
      version: 'weekly',
    });

    loader.load().then(() => {
      const map = new google.maps.Map(mapRef.current, {
        center: { lat: latitude, lng: longitude },
        zoom: 15,
      });
    });
  }, [latitude, longitude]);

  return <div ref={mapRef} className="w-full h-96" />;
};
```

### Floor Plan Integration

**Recommended Structure:**
```typescript
// components/FloorPlanViewer.tsx
const FloorPlanViewer = ({ floorPlanUrl }) => {
  return (
    <div className="floor-plan-container">
      <img 
        src={floorPlanUrl} 
        alt="Property floor plan"
        className="w-full h-auto"
      />
      {/* Add zoom and pan functionality */}
    </div>
  );
};
```

## 📱 Responsive Design

The application is fully responsive with breakpoints:
- **Mobile**: < 768px
- **Tablet**: 768px - 1024px  
- **Desktop**: > 1024px

Key responsive features:
- Adaptive grid layouts
- Collapsible navigation
- Touch-friendly interactions
- Optimized image loading

## 🔒 Security Considerations

### Content Security Policy
```html
<!-- Add to index.html -->
<meta http-equiv="Content-Security-Policy" 
      content="default-src 'self'; 
               img-src 'self' https://images.unsplash.com; 
               script-src 'self';">
```

### XSS Prevention
- All user inputs are properly sanitized
- React's JSX prevents direct DOM injection
- Content is escaped by default

## 📈 Performance Optimization

### Implemented Optimizations
- **Lazy Loading** - Images load on demand
- **Code Splitting** - Route-based chunking
- **Memoization** - React.memo for expensive components
- **Efficient State** - Minimal re-renders

### Further Improvements
- Add service worker for offline functionality
- Implement virtual scrolling for large datasets
- Use CDN for image assets
- Add Progressive Web App features

## 🧪 Testing

### Running Tests
```bash
npm run test
# or
yarn test
```

### Test Coverage
- Unit tests for utility functions
- Component testing with React Testing Library
- Integration tests for user workflows
- E2E tests with Playwright

## 🚀 Deployment

### Build for Production
```bash
npm run build
# or
yarn build
```

### Deployment Options
- **Vercel** - Automatic deployments from Git
- **Netlify** - Static site hosting with forms
- **GitHub Pages** - Free hosting for public repos
- **AWS S3** - Scalable cloud hosting

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Use TypeScript for all new code
- Follow existing naming conventions
- Add comprehensive comments
- Include unit tests for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Rightmove** - Inspiration for UI/UX design
- **Shadcn/ui** - Beautiful component library
- **Tailwind CSS** - Utility-first styling
- **Unsplash** - High-quality placeholder images
- **Lucide React** - Consistent icon system

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Email: support@propertyhub.dev
- Documentation: [Wiki](https://github.com/your-repo/wiki)

---

**PropertyHub** - Find Your Perfect Home 🏡
