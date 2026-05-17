import { Phone, Mail } from 'lucide-react';

const ContactForm = () => {
  return (
    <div className="bg-gray-100 py-16">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <h2 className="text-3xl font-bold text-gray-900 mb-4">Contact Us</h2>
          <p className="text-gray-600">Get in touch with our real estate experts</p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          <div className="bg-white p-6 rounded-lg shadow-md">
            <div className="flex items-center mb-4">
              <Phone className="h-5 w-5 text-yellow-700 mr-2" />
              <span className="text-gray-600">+1 (555) 123-4567</span>
            </div>
            <div className="flex items-center">
              <Mail className="h-5 w-5 text-yellow-700 mr-2" />
              <span className="text-gray-600">contact@dreamhome.com</span>
            </div>
          </div>
          <form className="bg-white p-6 rounded-lg shadow-md">
            <div className="grid grid-cols-2 gap-4 mb-4">
              <input
                type="text"
                placeholder="First Name"
                className="p-2 border border-gray-300 rounded focus:outline-none focus:border-yellow-700"
              />
              <input
                type="text"
                placeholder="Last Name"
                className="p-2 border border-gray-300 rounded focus:outline-none focus:border-yellow-700"
              />
            </div>
            <input
              type="email"
              placeholder="Email"
              className="w-full p-2 border border-gray-300 rounded focus:outline-none focus:border-yellow-700 mb-4"
            />
            <textarea
              placeholder="Message"
              rows={4}
              className="w-full p-2 border border-gray-300 rounded focus:outline-none focus:border-yellow-700 mb-4"
            ></textarea>
            <button className="w-full bg-yellow-700 text-white py-2 rounded hover:bg-yellow-800 transition-colors">
              Send Message
            </button>
          </form>
        </div>
      </div>
    </div>
  );
};

export default ContactForm;