<?php
// admin_products.php — Basic admin panel to list and edit products
include('db.php');
include('headfile.html');

$pagename = "Admin Product List";
echo "<h2>$pagename</h2>";

$sql = "SELECT prodId, prodName, prodPrice, prodQuantity FROM Product";
$result = mysqli_query($conn, $sql) or die(mysqli_error($conn));

echo "<table class='basket'>";
echo "<tr><th>ID</th><th>Name</th><th>Price</th><th>Quantity</th><th>Action</th></tr>";
while ($row = mysqli_fetch_assoc($result)) {
    echo "<tr>";
    echo "<td>" . $row['prodId'] . "</td>";
    echo "<td>" . htmlspecialchars($row['prodName']) . "</td>";
    echo "<td>£" . number_format($row['prodPrice'], 2) . "</td>";
    echo "<td>" . (int)$row['prodQuantity'] . "</td>";
    echo "<td><a href='edit_product.php?id=" . $row['prodId'] . "'>Edit</a></td>";
    echo "</tr>";
}
echo "</table>";

include('footfile.html');
?>