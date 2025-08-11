<?php
// basket.php
// Processes the posted quantity and product id from prodbuy.php and stores the selection in the PHP session

session_start(); // we will use session to hold basket data
include('db.php'); // optional — may be needed if you want to validate product id against DB

// Defensive checks for expected POST values
if (!isset($_POST['h_prodid']) || !isset($_POST['p_quantity'])) {
    // malformed request — redirect back to index
    header('Location: index.php');
    exit();
}

$prodid = (int)$_POST['h_prodid'];
$quantity = (int)$_POST['p_quantity'];

// Validate positive values
if ($prodid <= 0 || $quantity <= 0) {
    header('Location: index.php');
    exit();
}

// Optionally verify product exists and has enough stock
$sql = "SELECT prodId, prodName, prodPrice, prodQuantity FROM Product WHERE prodId = " . $prodid;
$res = mysqli_query($conn, $sql) or die(mysqli_error($conn));

if ($row = mysqli_fetch_assoc($res)) {
    $available = (int)$row['prodQuantity'];
    if ($quantity > $available) {
        // requested more than available — reduce to max available
        $quantity = $available;
    }

    // Initialize basket in session if not already
    if (!isset($_SESSION['basket'])) {
        $_SESSION['basket'] = array();
    }

    // If product already in basket, increment quantity
    if (isset($_SESSION['basket'][$prodid])) {
        $_SESSION['basket'][$prodid]['quantity'] += $quantity;
    } else {
        // Add new entry with product info
        $_SESSION['basket'][$prodid] = array(
            'prodId' => $prodid,
            'prodName' => $row['prodName'],
            'prodPrice' => $row['prodPrice'],
            'quantity' => $quantity
        );
    }

    // Redirect to a basket view page
    header('Location: basketview.php');
    exit();
} else {
    // Product doesn't exist — go back
    header('Location: index.php');
    exit();
}

?>