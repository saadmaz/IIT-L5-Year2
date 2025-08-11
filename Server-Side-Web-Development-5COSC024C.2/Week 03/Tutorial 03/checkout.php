<?php
// checkout.php — Mock checkout page
session_start();
include('headfile.html');

echo "<h2>Checkout</h2>";
if (!isset($_SESSION['basket']) || count($_SESSION['basket']) == 0) {
    echo "<p>Your basket is empty. <a href='index.php'>Continue shopping</a></p>";
    include('footfile.html');
    exit();
}

$total = 0;
echo "<form method='post'>";
echo "<table class='basket'>";
echo "<tr><th>Product</th><th>Price</th><th>Quantity</th><th>Subtotal</th></tr>";
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
echo "<p><button type='submit' name='confirm'>Confirm Order</button></p>";
echo "</form>";

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['confirm'])) {
    echo "<p>Thank you for your purchase! (Mock checkout)</p>";
    unset($_SESSION['basket']);
}

include('footfile.html');
?>