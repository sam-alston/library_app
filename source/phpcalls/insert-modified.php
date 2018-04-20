<?php
session_start();

$furn_id =  $_REQUEST['furn_id'];
$new_x = $_REQUEST['new_x'];
$new_y = $_REQUEST['new_y'];
$survey_id = $_REQUEST['survey_id'];
$in_area = $_REQUEST['in_area'];

$dbh = new PDO('mysql:host=localhost;dbname=hsu_library;charset=utf8mb4', 'root', '');	
$dbh->beginTransaction();
$insert_seat_stmt = $dbh->prepare('INSERT INTO modified_furniture(furniture_id, new_x, new_y, survey_id, in_area)
									VALUES(:furniture_id, :new_x, :new_y, :survey_id, :in_area)');

$insert_seat_stmt->bindParam(':furniture_id', $furn_id, PDO::PARAM_INT);
$insert_seat_stmt->bindParam(':new_x', $new_x, PDO::PARAM_STR);
$insert_seat_stmt->bindParam(':new_y', $new_y, PDO::PARAM_STR);
$insert_seat_stmt->bindParam(':survey_id', $survey_id, PDO::PARAM_INT);
$insert_seat_stmt->bindParam(':in_area', $in_area, PDO::PARAM_INT);

$insert_seat_stmt->execute();

$dbh->commit();