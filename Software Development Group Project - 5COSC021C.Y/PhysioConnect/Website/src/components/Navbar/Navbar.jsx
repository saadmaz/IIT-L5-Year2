import React, { useState } from "react";
import { Link } from "react-scroll";
import "./navbar.css";

const Navbar = () => {
  const [menuOpen, setMenuOpen] = useState(false);

  return (
    <nav className="navbar">
      <div className="container navbar-container">
        <div className="navbar-logo">
          <Link to="home" smooth={true} duration={800} onClick={() => setMenuOpen(false)}>
            PhysioConnect
          </Link>
        </div>

        <div className={`navbar-links ${menuOpen ? "open" : ""}`}>
          <Link to="features" smooth={true} duration={800} onClick={() => setMenuOpen(false)}>
            Features
          </Link>
          <Link to="how-it-works" smooth={true} duration={800} onClick={() => setMenuOpen(false)}>
            How It Works
          </Link>
          <Link to="about-us" smooth={true} duration={800} onClick={() => setMenuOpen(false)}>
            Our Team
          </Link>
          <Link to="contact" smooth={true} duration={800} onClick={() => setMenuOpen(false)}>
            Contact
          </Link>
        </div>

        <div className="menu-toggle" onClick={() => setMenuOpen(!menuOpen)}>
          <span></span>
          <span></span>
          <span></span>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
