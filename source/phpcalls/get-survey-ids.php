<?php
session_start();
require_once('./../config.php');

$get_date =  $_REQUEST['selected_date'];

$date_start = $get_date." 00::00::00";
$date_end = $get_date." 23::59::59";

$dbh = new PDO($dbhost, $dbh_select_user, $dbh_select_pw);

$stmt1 = $dbh->prepare("SELECT survey_id, layout_id FROM survey_record WHERE (survey_date BETWEEN :date_start AND :date_end)");
/*statment for after layout is selected*/
$stmt1->bindParam(':date_start', $date_start, PDO::PARAM_STR);
$stmt1->bindParam(':date_end', $date_end, PDO::PARAM_STR);

$stmt1->execute();

$survey_result = $stmt1->fetchAll();

print json_encode($survey_result);