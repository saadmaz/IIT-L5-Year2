import { useState } from "react";
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
        {/* Text removed as requested */}
      </div>
    </div>
  );
};

export default HeroSection;
