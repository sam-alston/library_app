<?php
session_start();
require_once('./../config.php');

$furn_id =  $_REQUEST['furn_id'];
$occupants = $_REQUEST['occupants'];
$survey_id = $_REQUEST['survey_id'];

$dbh = new PDO($dbhost, $dbh_insert_user, $dbh_insert_pw);
$dbh->beginTransaction();
$insert_seat_stmt = $dbh->prepare('INSERT INTO surveyed_room (furniture_id, total_occupants, survey_id)
                             	   VALUES (:furniture_id, :occupants, :survey_id)');

$insert_seat_stmt->bindParam(':furniture_id', $furn_id, PDO::PARAM_INT);
$insert_seat_stmt->bindParam(':occupants', $occupants, PDO::PARAM_INT);
$insert_seat_stmt->bindParam(':survey_id', $survey_id, PDO::PARAM_INT);

$insert_seat_stmt->execute();

$dbh->commit();