# PRODUCT PAGE — Full Project

## What you get
This package contains the following files:

- `index.php` — a simple product listing page (sample data) that links to `prodbuy.php` using a query string.
- `prodbuy.php` — the main product page (implements Task 01–04 from the tutorial).
- `db.php` — database connection file. Edit the connection variables at the top.
- `basket.php` — receives the POST from `prodbuy.php`, saves the item into the PHP session `$_SESSION['basket']`, and redirects to `basketview.php`.
- `basketview.php` — shows the contents of the shopping basket stored in the session.
- `headfile.html` and `footfile.html` — simple header/footer includes used by the pages.
- `mystylesheet.css` — minimal CSS for layout.
- `sql_setup.txt` — SQL script to create a sample `Product` table and insert sample records.

Also included in documentation are instructions on how to set up and run the app.

## Requirements
- PHP 7+ (with `mysqli` extension)
- MySQL or MariaDB
- A web server (Apache, Nginx) or PHP built-in server for quick testing

## Installation / Setup
1. Place all files in the same directory on your web server (e.g., `C:\homteq` on Windows or `/var/www/html/homteq` on Linux).
2. Import the `sql_setup.txt` into your MySQL database to create the `Product` table with sample data.
3. Edit `db.php` and set the `$host`, `$user`, `$pass`, and `$dbname` variables to match your DB credentials.
4. Ensure the `images/` folder contains the images referenced in the SQL sample (or edit the image file names in DB accordingly).
5. Open `index.php` in your browser. Click a product to go to `prodbuy.php`.

## Notes
- This code is intentionally simple for learning and demonstration. It does not implement advanced security features (input sanitization, prepared statements) — please harden it before using in production.
- Comments are included in every file to help you understand the flow.
