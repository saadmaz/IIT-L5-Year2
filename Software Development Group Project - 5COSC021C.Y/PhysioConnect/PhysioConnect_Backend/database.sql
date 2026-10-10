-- database.sql

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS physioconnect;
USE physioconnect;

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  profile_picture VARCHAR(255) DEFAULT NULL,
  phone_number VARCHAR(20) DEFAULT NULL,
  professional_credentials VARCHAR(255) DEFAULT NULL,
  years_of_experience INT DEFAULT 0,
  license_number VARCHAR(50) DEFAULT NULL,
  bio TEXT DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User specializations
CREATE TABLE IF NOT EXISTS user_specializations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  specialization VARCHAR(255) NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- User certifications
CREATE TABLE IF NOT EXISTS user_certifications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  certification VARCHAR(255) NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- User preferences
CREATE TABLE IF NOT EXISTS user_preferences (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL UNIQUE,
  is_dark_mode BOOLEAN DEFAULT FALSE,
  language VARCHAR(10) DEFAULT 'en',
  timezone VARCHAR(50) DEFAULT 'UTC',
  notifications_enabled BOOLEAN DEFAULT TRUE,
  message_notifications BOOLEAN DEFAULT TRUE,
  connection_request_notifications BOOLEAN DEFAULT TRUE,
  appointment_notifications BOOLEAN DEFAULT TRUE,
  certificate_expiry_notifications BOOLEAN DEFAULT TRUE,
  is_profile_public BOOLEAN DEFAULT TRUE,
  show_contact_info BOOLEAN DEFAULT FALSE,
  allow_connection_requests BOOLEAN DEFAULT TRUE,
  show_professional_network BOOLEAN DEFAULT TRUE,
  participate_in_recommendations BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Professional development
CREATE TABLE IF NOT EXISTS professional_developments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  type ENUM('course', 'workshop', 'conference', 'certification') NOT NULL,
  completion_date DATE NOT NULL,
  certificate_url VARCHAR(255) DEFAULT NULL,
  provider VARCHAR(255) DEFAULT NULL,
  credit_hours INT DEFAULT NULL,
  description TEXT DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Achievements (for mock data)
CREATE TABLE IF NOT EXISTS achievements (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  icon_url VARCHAR(255) DEFAULT NULL,
  awarded_date DATE NOT NULL,
  type VARCHAR(50) NOT NULL,
  progress INT NOT NULL DEFAULT 0,
  goal INT NOT NULL DEFAULT 0,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);