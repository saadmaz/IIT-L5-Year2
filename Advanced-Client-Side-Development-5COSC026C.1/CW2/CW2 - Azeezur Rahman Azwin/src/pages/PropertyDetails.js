import React from "react";
import { useParams } from "react-router-dom";
import data from "../data/properties.json";
import "../styles/global.css";

const PropertyDetails = () => {
  const { id } = useParams();
  const property = data.properties.find((p) => p.id === id);

  if (!property) {
    return <h1>Property not found</h1>;
  }

  return (
    <div>
      <h1>
        {property.type} in {property.location}
      </h1>
      <img className="main-image" src={property.picture + "1.jpg"} alt="Main property" />
      <img className="secondary-image" src={property.picture + "2.jpg"} alt="2 property" />
      <img className="secondary-image" src={property.picture + "3.jpg"} alt="3 property" />
      <img className="secondary-image" src={property.picture + "4.jpg"} alt="4 property" />
      <img className="secondary-image" src={property.picture + "5.jpg"} alt="5 property" />
      <img className="secondary-image" src={property.picture + "6.jpg"} alt="6 property" />
      <p>
        <strong>Price:</strong> £{property.price.toLocaleString()}
      </p>
      <p>
        <strong>Bedrooms:</strong> {property.bedrooms}
      </p>
      <p>
        <strong>Tenure:</strong> {property.tenure}
      </p>
      <p>{property.description}</p>
      <p>
        <strong>Added:</strong>{" "}
        {`${property.added.day} ${property.added.month}, ${property.added.year}`}
      </p>
    </div>
  );
};



export default PropertyDetails;
