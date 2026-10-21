import React from "react";
import { Link } from "react-scroll";
import { FaArrowUp } from "react-icons/fa";
import "./backtotop.css";

const BackToTop = () => {
  return (
    <div className="back-to-top">
      <Link to="hero" smooth={true} duration={800}>
        <FaArrowUp />
      </Link>
    </div>
  );
};

export default BackToTop;
