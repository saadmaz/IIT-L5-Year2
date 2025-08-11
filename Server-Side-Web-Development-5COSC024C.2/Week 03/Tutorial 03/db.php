<?php
// db.php
// Database connection file — include this on pages that need DB access.

// ---------- EDIT THESE VALUES ----------
$host = "localhost";    // database host (usually localhost)
$user = "root";         // database username
$pass = "your_password"; // database password
$dbname = "homteq_demo"; // database name created from sql_setup.txt
// ----------------------------------------

// Connect to MySQL using mysqli
$conn = mysqli_connect($host, $user, $pass, $dbname);

// Check for connection error and report it
if (!$conn) {
    // In production don't reveal sensitive details — just for the tutorial we show the error
    die("Database connection failed: " . mysqli_connect_error());
}

// Set charset to utf8mb4 for proper encoding
mysqli_set_charset($conn, "utf8mb4");

?>