import { useState, useEffect } from "react";
import { Element, animateScroll as scroll } from "react-scroll";
import Navbar from "../src/components/Navbar/Navbar";
import HomePage from "../src/pages/HomePage/HomePage";
import FeaturesPage from "../src/pages/FeaturesPage/FeaturesPage";
import AboutUs from "../src/pages/AboutUsPage/AboutUsPage";
import HowItWorks from "../src/pages/HowItWorksPage/HowItWorksPage";
import ContactPage from "../src/pages/ContactPage/ContactPage";
import Footer from "../src/components/Footer/Footer";
import "./App.css";

const App = () => {
  const [showButton, setShowButton] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      if (window.scrollY > 300) {
        setShowButton(true);
      } else {
        setShowButton(false);
      }
    };

    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <div className="App">
      {/* Navigation Bar - Fixed at top */}
      <Navbar />

      {/* Pages mapped to React Scroll Elements */}
      <Element name="home">
        <HomePage />
      </Element>

      <Element name="features">
        <FeaturesPage />
      </Element>

      <Element name="how-it-works">
        <HowItWorks />
      </Element>

      <Element name="about-us">
        <AboutUs />
      </Element>

      <Element name="contact">
        <ContactPage />
      </Element>

      {/* Footer Section */}
      <Footer />

      {/* Scroll to Top Button (Visible after scrolling down) */}
      {showButton && (
        <button className="back-to-top" onClick={() => scroll.scrollToTop()}>
          ⬆ Back to Top
        </button>
      )}
    </div>
  );
};

export default App;