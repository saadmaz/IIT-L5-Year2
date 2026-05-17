import Navbar from './components/Navbar/Navbar';
import Hero from './components/Hero/Hero';
import PropertyCard from './components/PropertyCard/PropertyCard';
import ContactForm from './components/ContactForm/ContactForm';
import Footer from './components/Footer/Footer';
import { featuredProperties } from './data/properties';

function App() {
  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      <Hero />
      
      {/* Featured Properties */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <h2 className="text-3xl font-bold text-gray-900 mb-8">Featured Properties</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {featuredProperties.map((property) => (
            <PropertyCard key={property.id} property={property} />
          ))}
        </div>
      </div>

      <ContactForm />
      <Footer />
    </div>
  );
}

export default App;