<?php
// basketview.php — Displays basket contents
session_start();
include('headfile.html');

echo "<h2>Your Basket</h2>";

if (!isset($_SESSION['basket']) || count($_SESSION['basket']) == 0) {
    echo "<p>Your basket is empty. <a href='index.php'>Continue shopping</a></p>";
    include('footfile.html');
    exit();
}

echo "<table class='basket'>";
echo "<tr><th>Product</th><th>Price</th><th>Quantity</th><th>Subtotal</th></tr>";
$total = 0;
foreach ($_SESSION['basket'] as $item) {
    $subtotal = $item['prodPrice'] * $item['quantity'];
    $total += $subtotal;
    echo "<tr>";
    echo "<td>" . htmlspecialchars($item['prodName']) . "</td>";
    echo "<td>£" . number_format($item['prodPrice'], 2) . "</td>";
    echo "<td>" . (int)$item['quantity'] . "</td>";
    echo "<td>£" . number_format($subtotal, 2) . "</td>";
    echo "</tr>";
}
echo "<tr><td colspan='3' style='text-align:right;'><strong>Total:</strong></td><td><strong>£" . number_format($total, 2) . "</strong></td></tr>";
echo "</table>";

echo "<p><a href='index.php'>Continue shopping</a> | <a href='checkout.php'>Proceed to checkout</a></p>";

include('footfile.html');
?>