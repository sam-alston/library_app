<?php
session_start();
require_once('./../config.php');
$area_ID =  $_REQUEST['area_ID'];
$dbh = new PDO($dbhost, $dbh_select_user, $dbh_select_pw);
$stmt1 = $dbh->prepare("SELECT * FROM area_vertices WHERE area_id = :area_ID ORDER BY load_order
");
/*statment for after layout is selected*/
$stmt1->bindParam(':area_ID', $area_ID, PDO::PARAM_INT);
$stmt1->execute();
$area_vertices_result = $stmt1->fetchAll();
$dbh= null;
print json_encode($area_vertices_result);