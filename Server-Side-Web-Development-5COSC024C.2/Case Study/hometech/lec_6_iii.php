<?php
include ("db.php"); //include db.php file to connect to DB


$sql = "INSERT INTO customer (fname,lname,cnumber)
VALUES('Theja','Perera',156454)";

if (mysqli_query($conn, $sql)) {
echo "New record created successfully";
}else {
echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

?>