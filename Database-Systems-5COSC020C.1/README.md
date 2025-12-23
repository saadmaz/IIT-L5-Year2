# Database Systems Repository

This repository contains all learning materials, practical work, and references related to the **Database Systems** module.
It is organized into **three main sections**, covering **database design**, **SQL querying**, and **XML technologies**, aligned with weekly lecture and tutorial content.

---

## 📌 Module Coverage Overview

* **Weeks 1–5**: Database Design (Conceptual & Logical Modeling)
* **Weeks 6–8**: SQL and Relational Querying
* **Weeks 10–12**: XML, XPath, XSLT, and XQuery

Each section builds on the previous one, moving from theory and modeling to implementation and advanced data querying.

---

## 🔧 Useful XML Tools

> *Note: The following tools are not part of the official module resources and are used only as supplementary aids for practice and validation.*

* **XML Formatter** – XML structure formatting
  [https://www.freeformatter.com/xml-formatter.html](https://www.freeformatter.com/xml-formatter.html)

* **XSD Validator** – XML schema validation
  [https://www.liquid-technologies.com/online-xsd-validator](https://www.liquid-technologies.com/online-xsd-validator)

* **XPath Utility** – XPath expression testing
  [https://www.easycodeforall.com/XPathUtility.jsp](https://www.easycodeforall.com/XPathUtility.jsp)

* **XSLT Transformer** – XML to HTML/text transformation
  [https://www.freeformatter.com/xsl-transformer.html](https://www.freeformatter.com/xsl-transformer.html)

* **XQuery & XPath Engine** – Query execution and testing
  [https://www.videlibri.de/cgi-bin/xidelcgi](https://www.videlibri.de/cgi-bin/xidelcgi)

---

## 📐 Section 01 – Database Design (Weeks 1–5)

This section focuses on the **conceptual and logical modeling** of database systems.

### Key Topics Covered

* **Conceptual Modeling (ERD / EERD)**

  * Use of **UML notation**
  * Identification of entities, attributes, and relationships
  * Definition of **multiplicity**, including:

    * **Cardinality** (maximum participation)
    * **Participation** (mandatory vs optional)

* **Enhanced Entity Concepts**

  * **Generalization and Specialization**
  * Use of **superclasses and subclasses**
  * Example: Modeling `Staff` into specialized roles such as `Manager` or `Technician`

* **Ternary Relationships**

  * Modeling relationships involving **three entities**
  * Example: A `Staff` member using a specific `Skill` on a `Project`

* **Logical Mapping to Relational Schema**

  * Converting ER/EER models into tables
  * Handling:

    * **Multi-valued attributes** using separate relations
    * **Recursive (unary) relationships** with renamed foreign keys (e.g., `ManagerStID`)
  * Enforcing constraints using:

    * `PRIMARY KEY`
    * `FOREIGN KEY`
    * `UNIQUE`
    * `NOT NULL`

---

## 🧮 Section 02 – SQL (Weeks 6–8)

This section focuses on **implementing and querying relational databases** using SQL.

### Key Topics Covered

* **Database Creation & Population**

  * Table creation scripts
  * Use of IDEs and **phpMyAdmin**
  * Defining primary and foreign keys

* **Core Querying**

  * `SELECT`, `FROM`, `WHERE`, `ORDER BY`
  * Filtering and sorting result sets

* **Join Operations**

  * **INNER JOIN** – combining related tables
  * **SELF JOIN** – querying hierarchical relationships (e.g., managers)
  * **OUTER JOIN**

    * `LEFT OUTER JOIN`
    * `RIGHT OUTER JOIN`

* **Aggregation & Grouping**

  * Use of:

    * `COUNT`
    * `SUM`
    * `AVG`
    * `MIN`
    * `MAX`
  * Grouping results using `GROUP BY`

* **Subqueries**

  * Nested queries for conditional logic
  * Example: Finding employees earning above the department average

---

## 🧾 Section 03 – XML (Weeks 10–12)

This section explores **XML-based data representation, navigation, transformation, and querying**.

### Key Topics Covered

* **XPath**

  * Navigating XML documents using path expressions
  * Selecting nodes using predicates
    Example:

    ```
    [SALARY >= 30000]
    ```

* **XSLT (eXtensible Stylesheet Language Transformations)**

  * Transforming XML into HTML or text formats
  * Use of:

    * `xsl:template`
    * `xsl:for-each`
  * Generating structured outputs such as reports or result sheets

* **XQuery**

  * Querying and restructuring XML data
  * Use of **FLWOR expressions**:

    * `FOR`
    * `LET`
    * `WHERE`
    * `ORDER BY`
    * `RETURN`
  * Advanced operations:

    * `distinct-values()`
    * Arithmetic calculations (e.g., final marks)

---

## 🧠 Conceptual Summary

Mastering this module is like **becoming both an architect and a librarian**:

* First, you design the blueprint of the system (**Database Design**)
* Then, you organize and retrieve information efficiently (**SQL**)
* Finally, you translate and transform data for broader use and interoperability (**XML**)
