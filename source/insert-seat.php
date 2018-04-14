<?php
session_start();

$furn_id =  $_REQUEST['furn_id'];
$occupied_state = $_REQUEST['occupied'];
$seat_position = $_REQUEST['seat_pos'];
$seat_type = $_REQUEST['seat_type'];
$survey_id = $_REQUEST['survey_id'];

$dbh = new PDO('mysql:host=localhost;dbname=hsu_library;charset=utf8mb4', 'root', '');	
$dbh->beginTransaction();
$insert_seat_stmt = $dbh->prepare('INSERT INTO seat (furniture_id, occupied, seat_position, seat_type, survey_id)
                             	   VALUES (:furniture_id, :occupied, :seat_pos, :seat_type, :survey_id)');

$insert_seat_stmt->bindParam(':furniture_id', $furn_id, PDO::PARAM_INT);
$insert_seat_stmt->bindParam(':occupied', $occupied_state, PDO::PARAM_INT);
$insert_seat_stmt->bindParam(':seat_pos', $seat_position, PDO::PARAM_INT);
$insert_seat_stmt->bindParam(':seat_type', $seat_type, PDO::PARAM_INT);
$insert_seat_stmt->bindParam(':survey_id', $survey_id, PDO::PARAM_INT);

$insert_seat_stmt->execute();

$dbh->commit();