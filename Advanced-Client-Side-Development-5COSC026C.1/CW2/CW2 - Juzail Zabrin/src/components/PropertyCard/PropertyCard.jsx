const PropertyCard = ({ property }) => {
  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden">
      <img
        src={property.image}
        alt={property.title}
        className="w-full h-48 object-cover"
      />
      <div className="p-6">
        <h3 className="text-xl font-semibold text-gray-900 mb-2">{property.title}</h3>
        <p className="text-2xl font-bold text-yellow-700 mb-4">{property.price}</p>
        <div className="flex justify-between text-gray-600">
          <span>{property.beds} beds</span>
          <span>{property.baths} baths</span>
          <span>{property.sqft} sq ft</span>
        </div>
      </div>
    </div>
  );
};

export default PropertyCard;