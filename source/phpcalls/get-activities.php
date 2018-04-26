<?php
	require_once('./../config.php');

	//get activities and populate activityMap
	$dbh = new PDO($dbhost, $dbh_select_user, $dbh_select_pw);

	$getActivities = $dbh->prepare('SELECT * FROM activity');

    $getActivities->execute();
	
	$activity_result = $getActivities->fetchAll();

	print json_encode($activity_result);