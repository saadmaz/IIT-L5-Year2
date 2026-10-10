import React, { useState } from "react";
import "../styles/signUpPage.css";
import { useNavigate } from "react-router-dom";

const SignUpPage = () => {
  const [userType, setUserType] = useState("");
  const [formStep, setFormStep] = useState(1);
  const [formData, setFormData] = useState({
    firstName: "",
    lastName: "",
    email: "",
    mobile: "",
    username: "",
    password: "",
    confirmPassword: "",
  });

  const navigate = useNavigate();

  const handleNextStep = () => {
    if (!userType) {
      alert("Please choose Customer or Vendor.");
      return;
    }
    if (formStep === 1) {
      if (formData.firstName && formData.lastName && formData.email && formData.mobile) {
        setFormStep(2);
      } else {
        alert("Please fill in all fields.");
      }
    } else if (formStep === 2) {
      if (!formData.username || !formData.password) {
        alert("Please enter a username and password.");
      } else if (formData.password === formData.confirmPassword) {
        alert(`Signed up as ${userType}`);
        navigate("/events");
      } else {
        alert("Passwords do not match.");
      }
    }
  };

  const handleInputChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  return (
    <div className="signup-container">
      <h1>Sign Up</h1>
      <div className="button-container">
        <button
          className={`user-type-button ${userType === "Customer" ? "active" : ""}`}
          onClick={() => setUserType("Customer")}
        >
          Customer
        </button>
        <button
          className={`user-type-button ${userType === "Vendor" ? "active" : ""}`}
          onClick={() => setUserType("Vendor")}
        >
          Vendor
        </button>
      </div>
      {formStep === 1 && (
        <div className="signup-form">
          <input
            type="text"
            name="firstName"
            placeholder="First Name"
            value={formData.firstName}
            onChange={handleInputChange}
          />
          <input
            type="text"
            name="lastName"
            placeholder="Last Name"
            value={formData.lastName}
            onChange={handleInputChange}
          />
          <input
            type="email"
            name="email"
            placeholder="Email Address"
            value={formData.email}
            onChange={handleInputChange}
          />
          <input
            type="tel"
            name="mobile"
            placeholder="Mobile Number"
            value={formData.mobile}
            onChange={handleInputChange}
          />
          <button className="next-button" onClick={handleNextStep}>
            Next
          </button>
        </div>
      )}
      {formStep === 2 && (
        <div className="signup-form">
          <input
            type="text"
            name="username"
            placeholder="Enter Username"
            value={formData.username}
            onChange={handleInputChange}
          />
          <input
            type="password"
            name="password"
            placeholder="Enter Password"
            value={formData.password}
            onChange={handleInputChange}
          />
          <input
            type="password"
            name="confirmPassword"
            placeholder="Confirm Password"
            value={formData.confirmPassword}
            onChange={handleInputChange}
          />
          <button className="next-button" onClick={handleNextStep}>
            Sign Up{userType && ` as ${userType}`}
          </button>
        </div>
      )}
    </div>
  );
};

export default SignUpPage;
