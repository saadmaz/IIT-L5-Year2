import React from "react";
import "./howitworkspage.css";
// Importing extracted data
import { steps } from "../../data/stepsData";

const HowItWorksPage = () => {
  return (
    <div className="how-it-works-page">
      <div className="container">
        <h1>How It Works</h1>
        <div className="steps-list">
          {steps.map((step, index) => (
            <div className="step-card" key={index}>
              <div className="step-icon">{step.icon}</div>
              <h2>{step.title}</h2>
              <p>{step.description}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default HowItWorksPage;
