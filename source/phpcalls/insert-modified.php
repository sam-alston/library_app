<?php
session_start();
require_once('./../config.php');

$furn_id =  $_REQUEST['furn_id'];
$new_x = $_REQUEST['new_x'];
$new_y = $_REQUEST['new_y'];
$degree_offset = $_REQUEST['degree_offset'];
$survey_id = $_REQUEST['survey_id'];
$in_area = $_REQUEST['in_area'];

$dbh = new PDO($dbhost, $dbh_insert_user, $dbh_insert_pw);	

$dbh->beginTransaction();
$insert_modified_stmt = $dbh->prepare('INSERT INTO modified_furniture(furniture_id, new_x, new_y, degree_offset, survey_id, in_area)
									VALUES(:furniture_id, :new_x, :new_y, :degree_offset, :survey_id, :in_area)');

$insert_modified_stmt->bindParam(':furniture_id', $furn_id, PDO::PARAM_INT);
$insert_modified_stmt->bindParam(':new_x', $new_x, PDO::PARAM_STR);
$insert_modified_stmt->bindParam(':new_y', $new_y, PDO::PARAM_STR);
$insert_modified_stmt->bindParam(':degree_offset', $degree_offset, PDO::PARAM_INT);
$insert_modified_stmt->bindParam(':survey_id', $survey_id, PDO::PARAM_INT);
$insert_modified_stmt->bindParam(':in_area', $in_area, PDO::PARAM_INT);

$insert_modified_stmt->execute();

$dbh->commit();