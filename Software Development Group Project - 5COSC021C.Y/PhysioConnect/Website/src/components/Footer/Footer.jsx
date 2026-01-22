import "react";
import { FaInstagram, FaLinkedin, FaFacebookF, } from "react-icons/fa";
import "./footer.css";

const Footer = () => {
  return (
    <footer className="footer">
      <div className="footer-content">
        
        {/* Brand & About Section */}
        <div className="footer-section about">
          <h2>PhysioConnect</h2>
          <p>Redefining physiotherapy with technology. Experience AI-driven recovery and innovative solutions for a healthier life.</p>
        </div>

        {/* Contact & Social Media */}
        <div className="footer-section contact">
          <h3>Contact Us</h3>
          <p>Email: <a href="mailto:support@physioconnect.com">support@physioconnect.online</a></p>
          <p>Phone: <a href="tel:+718709915">+94 71 870 9915</a></p>
          <div className="social-icons">
            <a href="https://www.instagram.com/physio_connect.online?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==" target="_blank" rel="noopener noreferrer"><FaInstagram /></a>
            <a href="https://www.linkedin.com/company/physioconnet-lk/?viewAsMember=true" target="_blank" rel="noopener noreferrer"><FaLinkedin /></a>
            <a href="https://www.facebook.com/share/18aDji3VAs/?mibextid=wwXIfr" target="_blank" rel="noopener noreferrer"><FaFacebookF /></a>
          </div>
        </div>

      </div>

      {/* Footer Bottom */}
      <div className="footer-bottom">
        <p>&copy; 2024 PhysioConnect. All Rights Reserved.</p>
      </div>
    </footer>
  );
};

export default Footer;
