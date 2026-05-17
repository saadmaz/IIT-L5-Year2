import React, { useState } from "react";
import { Link } from "react-router-dom";
import data from "../data/properties.json";
import PropertyCard from "../components/PropertyCard";
import SearchForm from "../components/SearchForm";

const SearchPage = () => {
  const [filteredProperties, setFilteredProperties] = useState(data.properties);

  const handleSearch = (criteria) => {
    console.log("Search criteria:", criteria); // Debug log

    const results = data.properties.filter((property) => {
      const matchesType =
        criteria.type === "any" ||
        property.type === criteria.type ||
        (criteria.type === "house" && property.type === "house") ||
        (criteria.type === "flat" && property.type === "flat");
      const matchesPrice =
        (!criteria.minPrice || property.price >= parseInt(criteria.minPrice)) &&
        (!criteria.maxPrice || property.price <= parseInt(criteria.maxPrice));
      const matchesBedrooms =
        (!criteria.minBedrooms ||
          property.bedrooms >= parseInt(criteria.minBedrooms)) &&
        (!criteria.maxBedrooms ||
          property.bedrooms <= parseInt(criteria.maxBedrooms));
      const matchesDate =
        !criteria.dateAdded ||
        new Date(
          `${property.added.year}-${String(property.added.month).padStart(
            2,
            "0"
          )}-${String(property.added.day + 1).padStart(2, "0")}`
        )
          .toISOString()
          .split("T")[0] === criteria.dateAdded;

      const matchesPostcode =
        !criteria.postcode || property.postcode === criteria.postcode;

      console.log("Property:", property); // Debug log
      console.log("Matches Type:", matchesType); // Debug log
      console.log("Matches Price:", matchesPrice); // Debug log
      console.log("Matches Bedrooms:", matchesBedrooms); // Debug log
      console.log("Matches Date:", matchesDate); // Debug log
      console.log("Matches Postcode:", matchesPostcode); // Debug log

      return (
        matchesType &&
        matchesPrice &&
        matchesBedrooms &&
        matchesDate &&
        matchesPostcode
      );
    });

    console.log("Filtered results:", results); // Debug log
    setFilteredProperties(results);
  };

  return (
    <div>
      <header>
        <h1>Properties.lk</h1>
        <div className="header-buttons">
          <Link to="/favourites">
            <button>View Favourites</button>
          </Link>
          <Link to="/about">
            <button>About</button>
          </Link>
          <Link to="/contact">
            <button>Contact Us</button>
          </Link>
        </div>
      </header>

      <main>
        <h1>Search Properties</h1>
        <SearchForm onSearch={handleSearch} />
        <div className="results">
          {filteredProperties.map((property) => (
            <PropertyCard key={property.id} property={property} />
          ))}
        </div>
      </main>

      <footer>
        <p>&copy; 2025 Your Company. All rights reserved.</p>
      </footer>
    </div>
  );
};

export default SearchPage;
