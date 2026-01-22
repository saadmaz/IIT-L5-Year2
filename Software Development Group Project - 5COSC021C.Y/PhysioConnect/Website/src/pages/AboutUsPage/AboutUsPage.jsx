import React from "react";
import { FaCrown, FaCode, FaRocket, FaPaintBrush, FaChartLine, FaMoneyBillWave } from "react-icons/fa";
import "./aboutuspage.css";

const teamMembers = [
  {
    name: "Himaza Zahara",
    role: "CEO (Chief Executive Officer)",
    secondaryRole: "Head of Strategy & Vision",
    icon: <FaCrown className="team-icon" />,
    image: "/assets/Himaza.png", // Corrected Path
  },
  {
    name: "Sachira Delankawala",
    role: "CMO (Chief Marketing Officer)",
    secondaryRole: "Lead Frontend Engineer",
    icon: <FaPaintBrush className="team-icon" />,
    image: "/assets/Sachira.png", // Corrected Path
  },
  {
    name: "Saad Mazhar",
    role: "COO (Chief Operations Officer)",
    secondaryRole: "Lead of Project Operations",
    icon: <FaCode className="team-icon" />,
    image: "/assets/Saad.png", // Corrected Path
  },
  {
    name: "Thejan Paranagama",
    role: "CTO (Chief Technology Officer)",
    secondaryRole: "Lead Backend Engineer",
    icon: <FaCode className="team-icon" />,
    image: "/assets/Thejan.png", // Corrected Path
  },
  {
    name: "Azeezur Rahmaan",
    role: "CIO (Chief Innovation Officer)",
    secondaryRole: "Lead AI & Data Science Incharge",
    icon: <FaRocket className="team-icon" />,
    image: "/assets/Azeez.png", // Corrected Path
  },
  {
    name: "Sathnara Perera",
    role: "CQA (Chief Quality Officer)",
    secondaryRole: "Lead QA Incharge",
    icon: <FaMoneyBillWave className="team-icon" />,
    image: "/assets/Sathnara.png", // Corrected Path
  },
];

const AboutUsPage = () => {
  return (
    <div className="about-us-page">
      <div className="header">
        <h1>Meet The Minds Behind PhysioConnect</h1>
        <p>
          A visionary team blending <strong>technology, innovation, and healthcare expertise</strong> to redefine physiotherapy solutions.
        </p>
      </div>

      <div className="team-section">
        {teamMembers.map((member, index) => (
          <div className="team-card" key={index}>
            <img src={member.image} alt={member.name} className="team-photo" />
            <div className="team-info">
              {member.icon}
              <h3>{member.name}</h3>
              <p className="role">{member.role}</p>
              <p className="secondary-role">{member.secondaryRole}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default AboutUsPage;
