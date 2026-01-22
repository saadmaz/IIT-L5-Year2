import React from "react";
import "./howitworkspage.css";
import { FaUserPlus, FaBullseye, FaHandsHelping, FaChartLine, FaUserMd, FaTrophy } from "react-icons/fa";

const steps = [
  {
    title: "Sign Up & Add Health Records",
    description: "Create an account and provide previous health records for better recommendations.",
    icon: <FaUserPlus />,
  },
  {
    title: "Choose Pain Points",
    description: "Select areas where you feel discomfort to receive tailored recovery plans.",
    icon: <FaBullseye />,
  },
  {
    title: "Get Customized Remedies",
    description: "Receive step-by-step tutorials and personalized DIY physiotherapy aids.",
    icon: <FaHandsHelping />,
  },
  {
    title: "Monitor & Track Recovery",
    description: "Log your pain levels and track your progress over time.",
    icon: <FaChartLine />,
  },
  {
    title: "Connect with Physiotherapists",
    description: "If necessary, consult with physiotherapists for professional guidance.",
    icon: <FaUserMd />,
  },
  {
    title: "Use Gamification for Perks",
    description: "Unlock premium features by engaging in daily exercises and challenges.",
    icon: <FaTrophy />,
  },
];

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
