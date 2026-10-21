<?php
session_start();
$pagename="Basket"; //Create and populate a variable called $pagename
include ("db.php");
echo "<link rel=stylesheet type=text/css href=mystylesheet.css>"; //Call in stylesheet
echo "<title>".$pagename."</title>"; //display name of the page as window title

echo "<body>";

include ("headfile.html"); //include header layout file

echo "<h4>".$pagename."</h4>"; //display name of the page on the web page
 //Call in stylesheet
//capture the ID of selected product using the POST method and the $_POST superglobal variable
//and store it in a new local variable called $newprodid
$newprodid=$_POST['h_prodid'];
//capture the required quantity of selected product using the POST method and $_POST superglobal variable
//and store it in a new local variable called $reququantity
$reququantity=$_POST['p_quantity'];
echo "<title>".$pagename."</title>"; //display name of the page as window title
$_SESSION['basket'][$newprodid]=$reququantity;
echo "<p>1 item added";
echo "<body>";
include ("headfile.html"); //include header layout file
echo "<h4>".$pagename."</h4>"; //display name of the page on the web page
$total= 0; //Create a variable $total and initialize it to zero
//Create HTML table with header to display the content of the basket: prod name, price, selected quantity and subtotal
echo "<p><table id='baskettable'>";
echo "<tr>";
echo "<th>Product Name</th><th>Price</th><th>Quantity</th><th>Subtotal</th>";
echo "</tr>";
//if the session array $_SESSION['basket'] is set
if (isset($_SESSION['basket']))
{
 //loop through the basket session array for each data item inside the session using a foreach loop 
 //to split the session array between the index and the content of the cell
 //for each iteration of the loop
 //store the id in a local variable $index & store the required quantity into a local variable $value
 foreach($_SESSION['basket'] as $newprodid => $reququantity)
 {
 //SQL query to retrieve from Product table details of selected product for which id matches $index
 //execute query and create array of records $arrayp
 $SQL="select prodId, prodName,prodPrice from product where prodId=".$newprodid;

 $exeSQL=mysqli_query($conn, $SQL) or die (mysql_error($conn));
 $arrayp=mysqli_fetch_array($exeSQL);
 echo "<tr>";
 //display product name & product price using array of records $arrayp
 echo "<td>".$arrayp['prodName']."</td>";
 echo "<td>&pound".number_format($arrayp['prodPrice'],2)."</td>";
 // display selected quantity of product retrieved from the cell of session array and now in $value
 echo "<td style='text-align:center;'>".$reququantity."</td>";
 //calculate subtotal, store it in a local variable $subtotal and display it
 $subtotal=$arrayp['prodPrice'] * $reququantity;
 echo "<td>&pound".number_format($subtotal,2)."</td>";
 echo "</tr>";
 //increase total by adding the subtotal to the current total
 $total=$total+$subtotal;
 }
}
//else display empty basket message
else 
{
echo "<p>Empty basket";
}
// Display total
echo "<tr>";
echo "<td colspan=3>TOTAL</td>";
echo "<td>&pound".number_format($total,2)."</td>";
echo "</tr>";
echo "</table>";

include("footfile.html"); //include head layout
echo "</body>";
?>