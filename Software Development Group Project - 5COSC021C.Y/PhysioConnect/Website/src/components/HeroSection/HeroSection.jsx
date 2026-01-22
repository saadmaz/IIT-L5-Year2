import  { useState } from "react";
import "./herosection.css";

const HeroSection = () => {
  const [isHovered, setIsHovered] = useState(false);

  return (
    <div className="hero-section">
      <video autoPlay muted loop className="hero-video">
        <source src="/assets/physioconnect_home.mp4" type="video/mp4" />
        Your browser does not support the video tag.
      </video>

      <div className="hero-content">
        <h1
          className={`hero-title ${isHovered ? "hovered" : ""}`}
          onMouseEnter={() => setIsHovered(true)}
          onMouseLeave={() => setIsHovered(false)}
        >
          Empower Your Recovery Anytime, Anywhere
        </h1>
      </div>
    </div>
  );
};

export default HeroSection;
