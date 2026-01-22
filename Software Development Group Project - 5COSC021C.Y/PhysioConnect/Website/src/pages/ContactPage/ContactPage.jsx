import React from "react";
import { Tab, Tabs, TabList, TabPanel } from "react-tabs";
import "react-tabs/style/react-tabs.css";
import "./contactpage.css";
import ContactForm from "../../components/ContactForm/ContactForm.jsx";
import { FaEnvelope, FaPhone, FaMapMarkerAlt } from "react-icons/fa";

const ContactPage = () => {
  return (
    <div className="contact-page">
      <div className="container">
        <h1>Contact Us</h1>
        <p className="contact-intro">
          Have questions or need help? Switch between tabs to contact us easily.
        </p>

        {/* React Tabs for Contact Page */}
        <Tabs className="tabs-container">
          <TabList className="tab-list">
            <Tab className="tab">Contact Form</Tab>
            <Tab className="tab">Reach Us</Tab>
          </TabList>

          {/* Contact Form Tab */}
          <TabPanel>
            <ContactForm />
          </TabPanel>

          {/* Reach Us Tab */}
          <TabPanel>
            <div className="contact-details">
              <div className="contact-item">
                <FaEnvelope className="contact-icon" />
                <p>Email: <a href="mailto:support@physioconnect.online">support@physioconnect.online</a></p>
              </div>
              <div className="contact-item">
                <FaPhone className="contact-icon" />
                <p>Phone: <a href="tel:+718709915">+718709915</a></p>
              </div>
              <div className="contact-item">
                <FaMapMarkerAlt className="contact-icon" />
                <p>Location: 30/1 Janatha Road, Maharagama</p>
              </div>
            </div>
          </TabPanel>
        </Tabs>
      </div>
    </div>
  );
};

export default ContactPage;
