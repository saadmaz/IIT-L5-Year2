import React from "react";
import "../styles/eventPage.css";

const EventPage = () => {
  const events = [
    { name: "Music Fest", date: "2024-12-20" },
    { name: "Art Expo", date: "2024-12-22" },
    { name: "Tech Summit", date: "2024-12-25" },
  ];

  return (
    <div className="event-container">
      <header className="event-header">Ticketing System</header>
      <main className="event-grid">
        {events.map((event) => (
          <div className="event-card" key={event.name}>
            <div className="event-banner" aria-hidden="true">{event.name}</div>
            <h3>{event.name}</h3>
            <p>{event.date}</p>
            <button className="read-more-button">Read More</button>
          </div>
        ))}
      </main>
    </div>
  );
};

export default EventPage;
