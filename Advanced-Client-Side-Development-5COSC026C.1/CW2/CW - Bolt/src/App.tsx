import React from 'react';
import { Home, Building2, Phone, Mail, Search } from 'lucide-react';

function App() {
  const featuredProperties = [
    {
      id: 1,
      title: "Luxury Villa with Ocean View",
      price: "$1,250,000",
      beds: 4,
      baths: 3,
      sqft: "3,500",
      image: "https://images.unsplash.com/photo-1613490493576-7fde63acd811?auto=format&fit=crop&w=800&q=80"
    },
    {
      id: 2,
      title: "Modern Downtown Apartment",
      price: "$550,000",
      beds: 2,
      baths: 2,
      sqft: "1,200",
      image: "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80"
    },
    {
      id: 3,
      title: "Suburban Family Home",
      price: "$850,000",
      beds: 3,
      baths: 2.5,
      sqft: "2,800",
      image: "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?auto=format&fit=crop&w=800&q=80"
    }
  ];

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Navigation */}
      <nav className="bg-white shadow-md">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            <div className="flex items-center">
              <Building2 className="h-8 w-8 text-blue-600" />
              <span className="ml-2 text-xl font-bold text-gray-900">DreamHome</span>
            </div>
            <div className="flex items-center space-x-4">
              <a href="#" className="text-gray-600 hover:text-blue-600">Buy</a>
              <a href="#" className="text-gray-600 hover:text-blue-600">Rent</a>
              <a href="#" className="text-gray-600 hover:text-blue-600">Sell</a>
              <a href="#" className="text-gray-600 hover:text-blue-600">Contact</a>
            </div>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <div className="relative bg-gray-900 h-[500px]">
        <img
          src="https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=2000&q=80"
          alt="Hero"
          className="w-full h-full object-cover opacity-50"
        />
        <div className="absolute inset-0 flex flex-col items-center justify-center text-center">
          <h1 className="text-4xl md:text-5xl font-bold text-white mb-6">
            Find Your Dream Home
          </h1>
          <div className="w-full max-w-3xl px-4">
            <div className="bg-white p-4 rounded-lg shadow-lg">
              <div className="flex items-center">
                <input
                  type="text"
                  placeholder="Enter location or property type..."
                  className="flex-1 p-2 border border-gray-300 rounded-l focus:outline-none focus:border-blue-500"
                />
                <button className="bg-blue-600 text-white px-6 py-2 rounded-r hover:bg-blue-700 transition-colors">
                  <Search className="h-5 w-5" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Featured Properties */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <h2 className="text-3xl font-bold text-gray-900 mb-8">Featured Properties</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {featuredProperties.map((property) => (
            <div key={property.id} className="bg-white rounded-lg shadow-md overflow-hidden">
              <img
                src={property.image}
                alt={property.title}
                className="w-full h-48 object-cover"
              />
              <div className="p-6">
                <h3 className="text-xl font-semibold text-gray-900 mb-2">{property.title}</h3>
                <p className="text-2xl font-bold text-blue-600 mb-4">{property.price}</p>
                <div className="flex justify-between text-gray-600">
                  <span>{property.beds} beds</span>
                  <span>{property.baths} baths</span>
                  <span>{property.sqft} sq ft</span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Contact Section */}
      <div className="bg-gray-100 py-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">Contact Us</h2>
            <p className="text-gray-600">Get in touch with our real estate experts</p>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div className="bg-white p-6 rounded-lg shadow-md">
              <div className="flex items-center mb-4">
                <Phone className="h-5 w-5 text-blue-600 mr-2" />
                <span className="text-gray-600">+1 (555) 123-4567</span>
              </div>
              <div className="flex items-center">
                <Mail className="h-5 w-5 text-blue-600 mr-2" />
                <span className="text-gray-600">contact@dreamhome.com</span>
              </div>
            </div>
            <form className="bg-white p-6 rounded-lg shadow-md">
              <div className="grid grid-cols-2 gap-4 mb-4">
                <input
                  type="text"
                  placeholder="First Name"
                  className="p-2 border border-gray-300 rounded focus:outline-none focus:border-blue-500"
                />
                <input
                  type="text"
                  placeholder="Last Name"
                  className="p-2 border border-gray-300 rounded focus:outline-none focus:border-blue-500"
                />
              </div>
              <input
                type="email"
                placeholder="Email"
                className="w-full p-2 border border-gray-300 rounded focus:outline-none focus:border-blue-500 mb-4"
              />
              <textarea
                placeholder="Message"
                rows={4}
                className="w-full p-2 border border-gray-300 rounded focus:outline-none focus:border-blue-500 mb-4"
              ></textarea>
              <button className="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700 transition-colors">
                Send Message
              </button>
            </form>
          </div>
        </div>
      </div>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-8">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col md:flex-row justify-between items-center">
            <div className="flex items-center mb-4 md:mb-0">
              <Building2 className="h-8 w-8 text-blue-400" />
              <span className="ml-2 text-xl font-bold">DreamHome</span>
            </div>
            <div className="flex space-x-6">
              <a href="#" className="hover:text-blue-400">Privacy Policy</a>
              <a href="#" className="hover:text-blue-400">Terms of Service</a>
              <a href="#" className="hover:text-blue-400">Contact</a>
            </div>
          </div>
          <div className="mt-4 text-center text-gray-400">
            © 2024 DreamHome. All rights reserved.
          </div>
        </div>
      </footer>
    </div>
  );
}

export default App;