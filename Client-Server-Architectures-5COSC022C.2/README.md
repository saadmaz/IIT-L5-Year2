# Client–Server Architectures

**Module Code:** 5COSC022C.2
**Module Title:** Client-Server Architectures

## 📌 Overview

This repository contains all learning materials, lab work, and coursework related to the **Client–Server Architectures** module. The module focuses on understanding, designing, and implementing client–server systems with a strong emphasis on **RESTful web services**, **backend architecture**, and **HTTP-based communication**.

The coursework component involves the design and implementation of a **RESTful Bookstore API** using **Java (JAX-RS)** and **JSON**, following strict technology constraints.

---

## 🎯 Learning Objectives

By completing this module, you will be able to:

* Understand client–server architectural principles
* Design RESTful APIs using HTTP methods and resource-based URLs
* Implement backend services using Java and JAX-RS
* Handle server-side validation, error handling, and HTTP status codes
* Work with in-memory data storage
* Test APIs using Postman
* Document and demonstrate backend systems professionally

---

## 🧠 Module Content Structure

### 📚 Weekly Content (Weeks 1–10)

Each week includes **lectures (LECs)** and **tutorials (TUTs)** covering both theory and practical concepts.

Typical topics include:

* Introduction to Client–Server Architectures
* HTTP, REST principles, and stateless communication
* RESTful API design
* JAX-RS fundamentals
* Resource classes and routing
* JSON data handling
* Exception handling and HTTP status codes
* API testing strategies
* Scalability and architectural considerations

> 📁 All weekly materials are organised by week folders (Week 01 → Week 10).

---

## 🧪 Lab-Based Practicals

The lab sessions focus on hands-on development, including:

* Creating REST endpoints using JAX-RS
* Handling GET, POST, PUT, DELETE requests
* Implementing validation logic
* Managing in-memory data using Java collections
* Testing endpoints using Postman

---

## 🛒 Coursework: RESTful Bookstore API

### 📌 Coursework Description

The coursework requires building a **backend RESTful API** for a **Bookstore system**.

The API manages:

* Books
* Authors
* Customers
* Shopping carts
* Orders

⚠️ **Important:** This is a **backend-only** project. No frontend is required or allowed as part of the coursework submission.

---

### 🛠️ Technology Stack

Mandatory technologies:

* **Java**
* **JAX-RS (Java API for RESTful Web Services)**
* **JSON**
* **Postman** (for testing and demonstration)

🚫 **Strictly Prohibited:**

* Spring / Spring Boot
* External databases (MySQL, PostgreSQL, etc.)
* Any frontend technologies (HTML, CSS, JS, React, etc.)

All data must be stored using **in-memory data structures** such as `ArrayList` and `HashMap`.

---

### 📦 Coursework Features

* RESTful resource design
* Proper use of HTTP methods and status codes
* In-memory data management
* Server-side validation
* Custom exception handling using `ExceptionMapper`
* Meaningful JSON error responses
* Fully testable endpoints via Postman

---

### 📑 Mandatory Deliverables

The coursework submission consists of **three required deliverables**:

1. **Project ZIP file**

   * Complete Java project source code

2. **Technical Report (PDF)**

   * API design explanation
   * Test cases
   * Sample requests and responses

3. **Video Demonstration**

   * API testing using **Postman**
   * Clear explanation of functionality

📊 **Weighting:** 60% of the final module grade
📅 **Submission Deadline:** 28 April 2025

---

## 🚀 Post-Course Extension (Optional)

After coursework submission, this backend API can be extended for **personal learning or portfolio purposes**, such as:

* Building a frontend client
* Deploying the API
* Replacing in-memory storage with a database

> ⚠️ These extensions **must not** be included in the coursework submission.

---

## 🧪 Running the Project

1. Import the project into an IDE (IntelliJ / Eclipse)
2. Deploy on **Apache Tomcat 9**
3. Use **Postman** to test API endpoints
4. Ensure the server is running before sending requests

---

## 📖 Notes

* Restarting the server will reset all data (in-memory storage).
* API responses strictly follow REST and JSON standards.
* Error handling is implemented using custom exceptions and HTTP status codes.

---

## 👤 Author

**Saad Mazhar**
Computer Science Undergraduate
University of Westminster (IIT Sri Lanka)