import React, { useState } from "react";
import "../styles/loginPage.css";
import { useNavigate } from "react-router-dom";

const LoginPage = () => {
  const [userType, setUserType] = useState("");
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();

  const handleLogin = () => {
    if (username && password && userType) {
      alert(`Logged in as ${userType}`);
      navigate("/events");
    } else {
      alert("Please fill in all fields.");
    }
  };

  return (
    <div className="login-container">
      <h1>Login</h1>
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
      <div className="login-form">
        <input
          type="text"
          placeholder="Enter Username"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
        />
        <input
          type="password"
          placeholder="Enter Password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        <button className="login-button" onClick={handleLogin}>
          Login
        </button>
      </div>
    </div>
  );
};

export default LoginPage;
