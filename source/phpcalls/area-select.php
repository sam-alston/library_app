<?php
session_start();
require_once('./../config.php');

$layout_ID =  $_REQUEST['layout_ID'];

$dbh = new PDO($dbhost, $dbh_select_user, $dbh_select_pw);

$stmt1 = $dbh->prepare("SELECT * FROM area WHERE area_id IN (SELECT area_id FROM area_in_layout WHERE layout_ID = :layout_ID)");
/*statment for after layout is selected*/
$stmt1->bindParam(':layout_ID', $layout_ID, PDO::PARAM_INT);

$stmt1->execute();



$area_result = $stmt1->fetchAll();
$dbh= null;


print json_encode($area_result);