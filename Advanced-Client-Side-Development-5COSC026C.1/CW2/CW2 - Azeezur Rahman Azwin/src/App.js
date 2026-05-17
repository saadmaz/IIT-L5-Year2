import React from "react";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import SearchPage from "./pages/SearchPage";
import PropertyDetails from "./pages/PropertyDetails";
import Favourite from "./pages/Favourite";
import About from "./pages/About";
import Contact from "./pages/Contact";

const App = () => (
  <Router>
    <Routes>
      <Route path="/" element={<SearchPage />} />
      <Route path="/property/:id" element={<PropertyDetails />} />
      <Route path="/favourites" element={<Favourite />} />
      <Route path="/about" element={<About />} />
      <Route path="/contact" element={<Contact />} />
    </Routes>
  </Router>
);

export default App;
