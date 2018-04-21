<?php
require_once('./../config.php');

$username = $_REQUEST['username'];
$layout_id = $_REQUEST['layout'];
$survey_date = date("Y-m-d h:i:sa");

$dbh = new PDO($dbhost, $dbh_insert_user, $dbh_insert_pw);
$dbh->beginTransaction();
$survey_r_query = $dbh->prepare('INSERT INTO survey_record (surveyed_by, layout_id, survey_date)
                                 VALUES (:username, :lay_id, :in_date)');


$dbh->setAttribute(PDO::ATTR_AUTOCOMMIT, FALSE);

$survey_r_query->bindParam(':username', $username, PDO::PARAM_STR);
$survey_r_query->bindParam(':lay_id', $layout_id, PDO::PARAM_INT);
$survey_r_query->bindParam(':in_date', $survey_date, PDO::PARAM_STR);

$survey_r_query->execute();
$data = array('s_id' => $dbh->lastInsertId());
$dbh->commit();

print json_encode($data);