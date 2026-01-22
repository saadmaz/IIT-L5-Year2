import React from "react";
import "./aboutuspage.css";
// Importing extracted data
import { teamMembers } from "../../data/teamData";

const AboutUsPage = () => {
  return (
    <div className="about-us-page">
      <div className="container">
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
    </div>
  );
};

export default AboutUsPage;
