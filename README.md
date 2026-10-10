# Second Year – Computing Modules Repository

This repository contains all academic materials from my **Second Year (Level 5)** of the Computing degree program at **Informatics Institute of Technology (IIT), Sri Lanka**, affiliated with the **University of Westminster**.

It includes lecture materials, tutorials, lab work, coursework implementations, and supporting resources across multiple core software engineering and web development modules.

🌐 **Live demo:** [PhysioConnect website](https://physioconnectweb.vercel.app) (Software Development Group Project)

---

## 📚 Modules Covered

| Module | Code | Folder |
|---|---|---|
| Object Oriented Programming | 5COSC019C | [`Object-Oriented-Programming-5COSC019C.1`](Object-Oriented-Programming-5COSC019C.1) |
| Database Systems | 5COSC020C | [`Database-Systems-5COSC020C.1`](Database-Systems-5COSC020C.1) |
| Software Development Group Project | 5COSC021C | [`Software Development Group Project - 5COSC021C.Y`](<Software Development Group Project - 5COSC021C.Y>) |
| Client-Server Architectures | 5COSC022C | [`Client-Server-Architectures-5COSC022C.2`](Client-Server-Architectures-5COSC022C.2) |
| Server-Side Web Development | 5COSC024C | [`Server-Side-Web-Development-5COSC024C.2`](Server-Side-Web-Development-5COSC024C.2) |
| Advanced Client-Side Development | 5COSC026C | [`Advanced-Client-Side-Development-5COSC026C.1`](Advanced-Client-Side-Development-5COSC026C.1) |
| Professional Development | 5COSC999C | [`Professional Development - 5COSC999C`](<Professional Development - 5COSC999C>) |

### 🔹 Object Oriented Programming
- Java fundamentals
- OOP concepts (classes, inheritance, polymorphism, encapsulation)
- Practical programming exercises and coursework

### 🔹 Database Systems
- Relational database concepts
- SQL queries and normalization
- Database design and implementation
- XML

### 🔹 Software Development Group Project (SDGP)
- Problem domain identification
- Requirements analysis
- Team-based software development practices
- Project planning and documentation

### 🔹 Client-Server Architectures
- Client-server communication models
- Socket programming and HTTP servers in Java
- RESTful web services with JAX-RS

### 🔹 Server-Side Web Development
- Backend development fundamentals
- Server-side logic and data handling
- Web application structure and workflows

### 🔹 Advanced Client-Side Development
- HTML5, CSS3, JavaScript
- Responsive design
- React fundamentals and advanced concepts
- Client-side security and API integration

### 🔹 Professional Development
- CV / résumé preparation and peer review

---

## 🚀 Project Highlights

| Project | Stack | Location |
|---|---|---|
| **PhysioConnect** – physiotherapy platform (group project) | Flutter, Node.js/Express, React + Vite | [`Software Development Group Project - 5COSC021C.Y/PhysioConnect`](<Software Development Group Project - 5COSC021C.Y/PhysioConnect>) |
| **Real-Time Event Ticketing System** | Java (CLI), Spring Boot, React | [`Object-Oriented-Programming-5COSC019C.1/CW`](Object-Oriented-Programming-5COSC019C.1/CW) |
| **RESTful Bookstore API** | Java, JAX-RS (Jersey), Maven | [`Client-Server-Architectures-5COSC022C.2/Coursework`](Client-Server-Architectures-5COSC022C.2/Coursework) |
| **Property search web app** (CW2) | React, TypeScript, Tailwind, Vite | [`Advanced-Client-Side-Development-5COSC026C.1/CW2`](Advanced-Client-Side-Development-5COSC026C.1/CW2) |

---

## 🗂 Repository Structure

Each module is organized into its own directory and may include:
- Lecture notes and slides
- Tutorials and lab exercises (`*-questions` folders are the original exercise templates; `*-answers` folders contain solutions)
- Coursework implementations
- Sample code and experiments
- Supporting documentation

---

## 🛠 Running the Code

Build outputs and dependencies (`node_modules/`, `target/`, `build/`) are not committed, so install them first:

- **Java / Maven projects:** `mvn test` (or open the folder in NetBeans / IntelliJ). Tutorial servers built on JAX-RS need a servlet container such as Apache Tomcat 9, which is not included in this repository.
- **React / Vite projects:** `npm install` then `npm run dev` (or `npm start` for Create React App projects).
- **Flutter apps:** `flutter pub get` then `flutter run`. The PhysioConnect app's nearby-facilities map needs a Google Places API key:
  `flutter run --dart-define=GOOGLE_PLACES_API_KEY=your_key`

---

## 🎯 Purpose of This Repository

- Academic reference for second-year modules
- Revision and learning archive
- Demonstration of technical progression
- Foundation for advanced coursework and projects

---

## ⚠️ Disclaimer

This repository is intended **for educational purposes only**.  
All work is my own unless stated otherwise and should not be copied for academic submissions. Lecture slides and tutorial templates belong to the module teaching teams, and folders named after other students contain their submissions, kept for reference.

---

## 📬 Contact

If you have questions, feedback, or would like to discuss any of the material:

- **GitHub:** [github.com/saadmaz](https://github.com/saadmaz)
- **Email:** saadmazaa@gmail.com
- **LinkedIn:** [linkedin.com/in/saadmaz](https://www.linkedin.com/in/saadmaz)

---

© Second Year Academic Work – All Rights Reserved
