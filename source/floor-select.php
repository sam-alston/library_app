<?php
session_start();

$floor_ID =  $_REQUEST['floor_ID'];

$dbh = new PDO('mysql:host=localhost;dbname=hsu_library;charset=utf8mb4', 'root', '');

$stmt1 = $dbh->prepare("SELECT floor FROM layout where floor = :floor");
/*statment for after layout is selected*/
$stmt1->bindParam(':floor', $_REQUEST['floor_ID'], PDO::PARAM_INT);

$stmt1->execute();

$floor_result = $stmt1->fetch(PDO::FETCH_ASSOC);

$_SESSION["cur_floor"] = $floor_result;

print json_encode($floor_result);