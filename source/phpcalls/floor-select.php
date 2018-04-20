<?php
session_start();
require_once('./../config.php');

$floor_ID =  $_REQUEST['floor_ID'];

$dbh = new PDO($dbhost, $dbh_select_user, $dbh_select_pw);

$stmt1 = $dbh->prepare("SELECT layout_id FROM layout where floor = :floor");
/*statment for after layout is selected*/
$stmt1->bindParam(':floor', $floor_ID, PDO::PARAM_INT);

$stmt1->execute();

$floor_result = $stmt1->fetchAll();
$dbh= null;

print json_encode($floor_result);