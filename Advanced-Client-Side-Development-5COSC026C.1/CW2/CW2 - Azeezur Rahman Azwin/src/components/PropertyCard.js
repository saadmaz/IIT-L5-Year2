import React from "react";
import { Link } from "react-router-dom";

const PropertyCard = ({ property }) => {
  const handleFavourite = () => {
    let favourites = JSON.parse(localStorage.getItem("favourites")) || [];
    if (!favourites.includes(property.id)) {
      favourites.push(property.id);
      localStorage.setItem("favourites", JSON.stringify(favourites));
    }
    console.log("Updated favourites:", favourites); // Debug log
  };

  return (
    <div className="property-card">
      <img src={property.picture + "1.jpg"} alt="Property" />
      <h2>
        {property.type} - £{property.price.toLocaleString()}
      </h2>
      <p>{property.bedrooms} Bedrooms</p>
      <p>{property.location}</p>
      <Link to={`/property/${property.id}`}>View Details</Link>
      <br></br>
      <button onClick={handleFavourite}>Favourite</button>
    </div>
  );
};

export default PropertyCard;
