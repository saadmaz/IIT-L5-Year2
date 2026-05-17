import React, { useState } from "react";

const SearchForm = ({ onSearch }) => {
  const [formValues, setFormValues] = useState({
    type: "any",
    minPrice: "",
    maxPrice: "",
    minBedrooms: "",
    maxBedrooms: "",
    dateAdded: "",
    postcode: "",
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormValues((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    onSearch(formValues);
  };

  return (
    <form onSubmit={handleSubmit} className="search-form">
      <label>
        Type:
        <select name="type" value={formValues.type} onChange={handleChange}>
          <option value="any">Any</option>
          <option value="house">House</option>
          <option value="flat">Flat</option>
        </select>
      </label>

      <label>
        Min Price:
        <input
          type="number"
          name="minPrice"
          value={formValues.minPrice}
          onChange={handleChange}
        />
      </label>

      <label>
        Max Price:
        <input
          type="number"
          name="maxPrice"
          value={formValues.maxPrice}
          onChange={handleChange}
        />
      </label>

      <label>
        Min Bedrooms:
        <input
          type="number"
          name="minBedrooms"
          value={formValues.minBedrooms}
          onChange={handleChange}
        />
      </label>

      <label>
        Max Bedrooms:
        <input
          type="number"
          name="maxBedrooms"
          value={formValues.maxBedrooms}
          onChange={handleChange}
        />
      </label>

      <label>
        Date Added:
        <input
          type="date"
          name="dateAdded"
          value={formValues.dateAdded}
          onChange={handleChange}
        />
      </label>

      <label>
        Postcode:
        <input
          type="text"
          name="postcode"
          value={formValues.postcode}
          onChange={handleChange}
        />
      </label>

      <button type="submit" className="search-button">
        Search
      </button>
    </form>
  );
};

export default SearchForm;
