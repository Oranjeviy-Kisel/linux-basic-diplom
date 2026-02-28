<?php

$servername = "10.100.10.8";
$username = "repl";
$password = "1234";
$dbname = "my_new_db";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
  echo "Connected successfully";
  die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT id, ProductName, Manufacturer FROM Products";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
  echo "<div class=\"main_page\"><div class=\"section_header\">Купи наши товары</div>";
  echo "<ul><li class=\"thead\"><span>ID</span><span>Продукт</span><span>Вендор</span></li>";
  
  while($row = $result->fetch_assoc()) {
    echo "<li><span>" . $row["id"]. "</span><span>" . $row["ProductName"]."</span><span>" . $row["Manufacturer"]. "</span></li>";
  }
  echo "</ul></div>";
} else {
  echo "<div>0 results</div>";
}


// Close the connection
$conn->close();

?>
