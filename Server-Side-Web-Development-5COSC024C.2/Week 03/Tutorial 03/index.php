<?php
// index.php
// Minimal product listing page that links to prodbuy.php with a query string

$pagename = "Product Index";
include('db.php');
include('headfile.html');

echo "<h2>$pagename</h2>";

// Fetch all products from DB and show small cards with links to prodbuy.php
$sql = "SELECT prodId, prodName, prodPicNameLarge, prodPrice, prodQuantity FROM Product";
$result = mysqli_query($conn, $sql) or die(mysqli_error($conn));

echo "<div class='product-grid'>";
while ($row = mysqli_fetch_assoc($result)) {
    // Create a URL that passes u_prod_id in the query string
    $link = "prodbuy.php?u_prod_id=" . $row['prodId'];

    echo "<div class='product-card'>";
    echo "  <a href='$link'>";
    echo "    <img src='images/" . htmlspecialchars($row['prodPicNameLarge']) . "' alt='" . htmlspecialchars($row['prodName']) . "' class='thumb'/>";
    echo "  </a>";
    echo "  <h3>" . htmlspecialchars($row['prodName']) . "</h3>";
    echo "  <p>Price: £" . number_format($row['prodPrice'], 2) . "</p>";
    echo "</div>";
}
echo "</div>";

include('footfile.html');
?>