# 5COSC026W – Advanced Client-side Web Development

## Final Coursework

### Estate Agent Client-side Web Application

---

### 📌 Module Information

* **Module Code:** 5COSC026W
* **Module Title:** Advanced Client-side Web Development
* **Assessment:** Final Coursework
* **Set Date:** 05th November 2024
* **Submission Deadline:** 22nd December 2024 – 1:00 PM (Blackboard)
* **Viva:** Date TBC

---

## 📖 Project Overview

This project is a **client-side estate agent web application** inspired by platforms such as **Rightmove.co.uk**.
The application allows users to **search, view, and favourite properties** using multiple criteria, implemented entirely on the **frontend using React JS**, without any server-side technologies.

All data is stored and managed using **JSON files and browser local storage**, ensuring the solution works **fully offline in a browser environment**.

---

## 🎯 Functional Requirements

### 🔍 Property Search Functionality

Users can search properties using any combination of the following criteria:

* **Property Type:** House, Flat, Any
* **Price Range:** Minimum and Maximum Price
* **Bedrooms:** Minimum and Maximum Bedrooms
* **Date Added:** After a specific date or between two dates
* **Postcode Area:** First part of the postcode (e.g., BR1, NW1)

✔ The search works with **1 or more criteria simultaneously**
✔ Results update dynamically on the client side

---

## 📊 Property Data (JSON)

* The application uses a **local JSON file** (no backend server)
* Initially provided with **2 properties**
* **5 additional properties** were added to cover a range of:

  * Property types
  * Prices
  * Bedrooms
  * Dates added
  * Postcode areas
* **Total properties:** 7

---

## 🧩 React & UI Implementation

### React Features Used

* Functional Components
* React Hooks (useState, useEffect)
* Component Lifecycle concepts
* JSX rendering
* Conditional rendering

### UI Enhancements

* React UI widgets used for **all form inputs**, including:

  * Property type selector
  * Price range inputs
  * Bedroom inputs
  * Date picker
  * Search button
* Ensures:

  * Consistency
  * Accessibility
  * Reliability

---

## 🖼️ Search Results Display

* Properties matching the search criteria are displayed on the **search page**
* Each result includes:

  * Property image
  * Short description
  * Price
* Layout is visually clean, structured, and user-friendly

> If search functionality fails, properties are still displayed to allow marks for layout and presentation.

---

## 🏠 Property Details Page

Each property has its own **dedicated page** containing:

* Large main image
* Thumbnail images
* Property summary:

  * Type
  * Price
  * Location
* **6–8 images per property**
* Image viewing implemented using:

  * Custom code or
  * A React-compatible image plugin

---

## 📑 Tabs (React UI Tabs)

Using **React Tabs**, the following sections are displayed on the property page:

* **Long Description**
* **Floor Plan**
* **Google Map Location**

---

## ⭐ Favourites Functionality (Local Storage)

Users can manage favourite properties in multiple ways:

### Add to Favourites

* Drag and drop a property to the favourites list
* Click a **favourite icon/button**
* Each property can only be added **once**

### Remove from Favourites

* Drag property out of the favourites list
* Click delete/remove button

### Clear Favourites

* Clear entire favourites list with a single action

### Persistent Storage

* Favourites are saved using **browser local storage**
* Favourites are displayed on:

  * Property page
  * Search page

---

## 📱 Responsive Web Design (RWD)

The application is fully responsive using:

* **Flexbox and/or CSS Grid**
* **Hand-written media queries**
* Optional use of frameworks (e.g., Bootstrap)

### Responsive Layouts

* **Large screens**
* **Smaller than iPad landscape width**
* Covers:

  * Search form
  * Results section
  * Individual property pages

Design choices can be **justified during the viva**.

---

## 🎨 Aesthetics & UI Design

The application follows strong visual design principles:

* Clear visual hierarchy
* Logical grouping of related elements
* Consistent alignment and spacing
* Balanced layout and harmony
* Limited font styles (maximum two)
* Consistent colour scheme
* Effective use of images and icons
* Clear focus on important information

---

## 🔐 Client-side Security

The application implements client-side security measures including:

* **Content Security Policy (CSP)** (conceptual explanation required in viva)
* Safe rendering using JSX (`{}`) to prevent injection
* No direct DOM manipulation
* No use of `dangerouslySetInnerHTML`

---

## 🚫 Constraints & Rules

* ❌ No server-side technologies
* ❌ No existing templates
* ✔ Must run directly in a browser
* ✔ Consistent behaviour across browsers
* ✔ Code must be well-commented and properly indented

Up to **10 marks may be deducted** for:

* Poor commenting
* Incorrectness
* Bad coding standards

---

## 🧪 Viva Examination

* Viva is **mandatory**
* Students must explain:

  * Code structure
  * Design choices
  * Search logic
  * State management
  * Local storage usage
  * Security considerations
* Failure to attend viva limits marks to **0–30%**

---

## 📌 Marking Rubric Summary

| Area                          | Marks |
| ----------------------------- | ----- |
| JSON Data                     | 5%    |
| React UI Widgets              | 10%   |
| Search Functionality          | 10%   |
| Results Display               | 10%   |
| Image Gallery                 | 10%   |
| Tabs (Description, Plan, Map) | 10%   |
| Save to Favourites            | 10%   |
| Remove / Clear Favourites     | 10%   |
| Read from Local Storage       | 5%    |
| Responsive Design             | 10%   |
| Aesthetics                    | 5%    |
| Security                      | 5%    |

---

## 👤 Academic Integrity

This is **individual coursework**.
No collaboration is permitted.
All work must be original and demonstrable during the viva.