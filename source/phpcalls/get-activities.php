<?php
	//get activities and populate activityMap
	$dbh = new PDO('mysql:host=localhost;dbname=hsu_library;charset=utf8mb4', 'root', '');

	$getActivities = $dbh->prepare('SELECT * FROM activity');

    $getActivities->execute();
	
	$activity_result = $getActivities->fetchAll();

	print json_encode($activity_result);