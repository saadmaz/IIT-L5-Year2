<?php
include ("db.php"); //include db.php file to connect to DB
$fname=$_POST["fname"];
$lname=$_POST["lname"];
$num=$_POST["num"];

$sql = "INSERT INTO customer (fname,lname,cnumber)
VALUES('".$fname."','".$lname."','".$num."')";

if (mysqli_query($conn, $sql)) {
echo "New record created successfully";
}else {
echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

?>