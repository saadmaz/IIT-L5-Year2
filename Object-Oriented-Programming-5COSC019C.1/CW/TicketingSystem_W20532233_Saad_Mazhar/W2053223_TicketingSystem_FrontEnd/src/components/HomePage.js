import React from "react";
import { Link } from "react-router-dom";
import "../styles/homePage.css";

const HomePage = () => {
  return (
    <div className="home-container">
      <header className="home-header">
        <div className="header-left">Ticketing System</div>
        <div className="header-right">
          <Link to="/signup">
            <button className="button">Sign Up</button>
          </Link>
          <Link to="/login">
            <button className="button">Login</button>
          </Link>
        </div>
      </header>
      <main className="home-body">
        <h1>Experience the Best Events Near You</h1>
        <h2>Find, Book, and Enjoy – It’s That Simple!</h2>
        <Link to="/events">
          <button className="explore-button">Explore the Events</button>
        </Link>
      </main>
    </div>
  );
};

export default HomePage;
