<?php
require_once('./../config.php');
$username = $_REQUEST['username'];
$floor = $_REQUEST['floor'];
$date_created = date("Y-m-d h:i:sa");

$dbh = new PDO($dbhost, $dbh_insert_user, $dbh_insert_pw);
$dbh->beginTransaction();
$insert_layout_stmt = $dbh->prepare('INSERT INTO layout (author, floor, date_created)
                                 VALUES (:username, :floor, :date_created)');


$dbh->setAttribute(PDO::ATTR_AUTOCOMMIT, FALSE);

$insert_layout_stmt->bindParam(':username', $username, PDO::PARAM_STR);
$insert_layout_stmt->bindParam(':floor', $floor, PDO::PARAM_INT);
$insert_layout_stmt->bindParam(':date_created', $date_created, PDO::PARAM_STR);

$insert_layout_stmt->execute();
$data = array('layout_id' => $dbh->lastInsertId());
$dbh->commit();

print json_encode($data);