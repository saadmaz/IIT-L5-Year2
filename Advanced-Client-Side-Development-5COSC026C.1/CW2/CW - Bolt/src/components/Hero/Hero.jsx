import { Search } from 'lucide-react';

const Hero = () => {
  return (
    <div className="relative bg-gray-900 h-[500px]">
      <img
        src="/images/hero.jpg"
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
                className="flex-1 p-2 border border-gray-300 rounded-l focus:outline-none focus:border-yellow-700"
              />
              <button className="bg-yellow-700 text-white px-6 py-2 rounded-r hover:bg-yellow-800 transition-colors">
                <Search className="h-5 w-5" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Hero;