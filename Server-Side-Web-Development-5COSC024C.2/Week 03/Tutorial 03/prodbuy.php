<?php
// prodbuy.php
// Implements Tasks 01 - 04 from the tutorial
// Shows the selected product, its details, and allows quantity selection up to stock level

$pagename = "A smart buy for a smart home";
include('db.php'); // include DB connection
include('headfile.html');

echo "<h4>" . $pagename . "</h4>";

// ------------------ TASK 01: Retrieve the product id ------------------
// Use $_GET to capture the u_prod_id passed in the URL by index.php
if (isset($_GET['u_prod_id']) && is_numeric($_GET['u_prod_id'])) {
    $prodid = (int)$_GET['u_prod_id']; // cast to int for safety
} else {
    // If no product id present, show message and exit
    echo "<p style='color:red;'>No product selected. Please go back to the <a href='index.php'>index</a>.</p>";
    include('footfile.html');
    exit();
}

// Display the product id for debugging/confirmation
echo "<p><strong>Selected product Id:</strong> " . $prodid . "</p>";

// ------------------ TASK 02: Retrieve product details ------------------
// Build SQL query to fetch the fields we need (large image, long description, price, quantity)
$sql = "SELECT prodId, prodName, prodPicNameLarge, prodDescripLong, prodPrice, prodQuantity
        FROM Product
        WHERE prodId = " . $prodid;

$result = mysqli_query($conn, $sql) or die(mysqli_error($conn));

// If the product exists, fetch and display its details
if ($row = mysqli_fetch_assoc($result)) {
    echo "<div class='prodbuy-wrapper'>";

    // Left column: Large image
    echo "<div class='prod-left'>";
    $imgSrc = 'images/' . htmlspecialchars($row['prodPicNameLarge']);
    echo "<img src='" . $imgSrc . "' alt='" . htmlspecialchars($row['prodName']) . "' class='large' />";
    echo "</div>";

    // Right column: Details
    echo "<div class='prod-right'>";
    echo "<h2>" . htmlspecialchars($row['prodName']) . "</h2>";
    echo "<p>" . nl2br(htmlspecialchars($row['prodDescripLong'])) . "</p>";
    echo "<p><strong>Price:</strong> £" . number_format($row['prodPrice'], 2) . "</p>";
    echo "<p><strong>Stock available:</strong> " . (int)$row['prodQuantity'] . "</p>";

    // ------------------ TASK 03 & 04: Add quantity selector ------------------
    // Use a form that posts to basket.php. We will generate a dynamic dropdown from 1..stock
    echo "<form action='basket.php' method='post'>";
    echo "  <label for='p_quantity'>Number to be purchased: </label>";

    // If no stock, disable selection and button
    $stock = (int)$row['prodQuantity'];
    if ($stock <= 0) {
        echo "<p style='color:red;'>Out of stock</p>";
    } else {
        echo "  <select name='p_quantity' id='p_quantity'>";
        for ($i = 1; $i <= $stock; $i++) {
            echo "<option value='" . $i . "'>" . $i . "</option>";
        }
        echo "  </select>";

        echo "  <br/><br/>";
        echo "  <input type='submit' name='submitbtn' value='ADD TO BASKET' id='submitbtn' />";
        // hidden field to pass prod id
        echo "  <input type='hidden' name='h_prodid' value='" . $prodid . "' />";
    }

    echo "</form>";

    echo "</div>"; // prod-right
    echo "</div>"; // wrapper

} else {
    echo "<p style='color:red;'>Product not found. Please return to <a href='index.php'>index</a>.</p>";
}

include('footfile.html');
?>