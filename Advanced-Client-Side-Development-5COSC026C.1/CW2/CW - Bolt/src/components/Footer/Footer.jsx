import { Building2 } from 'lucide-react';

const Footer = () => {
  return (
    <footer className="bg-gray-900 text-white py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col md:flex-row justify-between items-center">
          <div className="flex items-center mb-4 md:mb-0">
             <Building2 className="h-8 w-8 text-yellow-500" />
            <span className="ml-2 text-xl font-bold">DreamHomehj</span>
          </div>
          <div className="flex space-x-6">
            <a href="#" className="hover:text-yellow-500">Privacy Policy</a>
            <a href="#" className="hover:text-yellow-500">Terms of Service</a>
            <a href="#" className="hover:text-yellow-500">Contact</a>
          </div>
        </div>
        <div className="mt-4 text-center text-gray-400">
          © 2024 DreamHome. All rights reserved.
        </div>
      </div>
    </footer>
  );
};

export default Footer;