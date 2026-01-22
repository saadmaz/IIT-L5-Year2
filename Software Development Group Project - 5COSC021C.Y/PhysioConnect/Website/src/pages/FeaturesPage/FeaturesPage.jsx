import React, { useState } from "react";
import "./featurespage.css";
import { Tab, Tabs, TabList, TabPanel } from "react-tabs";
import "react-tabs/style/react-tabs.css";
// Importing extracted data
import { features } from "../../data/featuresData";

const FeaturesPage = () => {
  const [tabIndex, setTabIndex] = useState(0);

  return (
    <div className="features-page">
      <div className="container">
        <h1>Explore Our Features</h1>
        <Tabs selectedIndex={tabIndex} onSelect={(index) => setTabIndex(index)}>
          <TabList>
            {Object.keys(features).map((category, index) => (
              <Tab key={index}>{category}</Tab>
            ))}
          </TabList>

          {Object.entries(features).map(([category, featureList], index) => (
            <TabPanel key={index}>
              <div className="features-list">
                {featureList.map((feature, idx) => (
                  <div className="feature-card" key={idx}>
                    <div className="feature-icon">{feature.icon}</div>
                    <h2>{feature.title}</h2>
                    <p>{feature.description}</p>
                  </div>
                ))}
              </div>
            </TabPanel>
          ))}
        </Tabs>
      </div>
    </div>
  );
};

export default FeaturesPage;
