import React, { useEffect, useState } from "react";
import PropertyCardFav from "../components/PropertyCardFav";
import data from "../data/properties.json";

const Favourite = () => {
  const [favourites, setFavourites] = useState([]);

  useEffect(() => {
    const savedFavourites =
      JSON.parse(localStorage.getItem("favourites")) || [];
    const favouriteProperties = data.properties.filter((property) =>
      savedFavourites.includes(property.id)
    );
    setFavourites(favouriteProperties);
  }, []);

  const handleRemove = (id) => {
    setFavourites((prevFavourites) =>
      prevFavourites.filter((property) => property.id !== id)
    );
  };

  return (
    <div>
      <h1>Favourite Properties</h1>
      <div className="results">
        {favourites.length > 0 ? (
          favourites.map((property) => (
            <PropertyCardFav
              key={property.id}
              property={property}
              onRemove={handleRemove}
            />
          ))
        ) : (
          <p>No favourite properties found.</p>
        )}
      </div>
    </div>
  );
};

export default Favourite;
