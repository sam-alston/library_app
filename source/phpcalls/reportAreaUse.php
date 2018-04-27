<?php
	session_start();
	require_once('../config.php');
	//retrieve survey_id from ajax call.
	$survey_id =  $_REQUEST['survey_id'];
	//setup connection to DB
	$dbh = new PDO($dbhost, $dbh_select_user, $dbh_select_pw);
	//prepare stmt to get layout_id from survey_id
	$layoutStmt = $dbh->prepare("SELECT layout_id FROM survey_record WHERE survey_id = :survey_id");
	$layoutStmt->bindParam(':survey_id', $survey_id, PDO::PARAM_INT);
	//execute and retrieve
	$layoutStmt->execute();
	$layout_id = $layoutStmt->fetchColumn();

	
	//Prepare stmt to get areas in layout
	$areaStmt = $dbh->prepare("SELECT * FROM area WHERE area_id IN (SELECT area_id FROM area_in_layout WHERE layout_id = :layout_id)");
	$areaStmt->bindParam(':layout_id', $layout_id, PDO::PARAM_INT);
	//execute and retrieve areas
	$areaStmt->execute();
	$area_result = $areaStmt->fetchAll();
	
	$stmt = $dbh->prepare("select * from area");
	$stmt->execute();
	$tempArea = $stmt->fetchAll();
	
	//make a return variable to push strings onto.
	$returnString = $area_result;
	
	//for each area, we will sum the number of default seats and count the occupied ones.
	foreach ($area_result as $row) {
		$returnString = "Entered foreach";
		$area_id = $row["area_id"];
		$area_name = $row["name"];
		//get the total occupied seats in this area for this layout.
		$occupiedStmt = $dbh->prepare("select count(*) from seat where furniture_id IN 
					(select furniture_id from furniture where survey_id=:survey_id and in_area= :area_id)
					and occupied = 1");
		$occupiedStmt->bindParam(':survey_id', $survey_id, PDO::PARAM_INT);
		$occupiedStmt->bindParam(':area_id', $area_id, PDO::PARAM_INT);

		$occupiedStmt->execute();
		
		$totalOccupiedSeats = $occupiedStmt->fetchColumn();
		
		//get the total number of seats in this area for this layout.
		$totalSeatStmt = $dbh->prepare("SELECT SUM(number_of_seats) FROM furniture_type JOIN furniture ON furniture.furniture_type = furniture_type.furniture_type_id where furniture.layout_id = :layout_id AND furniture.in_area = :area_id");
		$totalSeatStmt->bindParam(':layout_id', $layout_id, PDO::PARAM_INT);
		$totalSeatStmt->bindParam(':area_id', $area_id, PDO::PARAM_INT);

		$totalSeatStmt->execute();
		
		$totalNumberSeats = $totalSeatStmt->fetchColumn();
		//print to screen
		if($totalNumberSeats == 0){
			//this is a room area
			//select furniture id of the room in this area
			$roomIdStmt = $dbh->prepare("SELECT furniture_id FROM furniture WHERE layout_id = :layout_id AND in_area = :in_area");
			$roomIdStmt->bindParam(':layout_id', $layout_id, PDO::PARAM_INT);
			$roomIdStmt->bindParam(':in_area', $area_id, PDO::PARAM_INT);
			
			$roomIdStmt->execute();
			$roomId = $roomIdStmt->fetchColumn();
			
			//now select total occupants of the room
			$roomOccupantStmt = $dbh->prepare("SELECT total_occupants FROM surveyed_room WHERE furniture_id = :furniture_id AND survey_id = :survey_id");
			$roomOccupantStmt->bindParam(':furniture_id', $roomId, PDO::PARAM_INT);
			$roomOccupantStmt->bindParam(':survey_id', $survey_id, PDO::PARAM_INT);
			
			$roomOccupantStmt->execute();
			$roomOccupants = 0;
			$roomOccupants += $roomOccupantStmt->fetchColumn();
			print $area_name . " total occupants: " . $roomId . " <br/>";
		} else {
			print $area_name  . " use ratio: " . $totalOccupiedSeats . " / " . $totalNumberSeats . "= " . $totalOccupiedSeats/$totalNumberSeats . " <br/>";

		}
		
	}

	$dbh= null;
	//print $returnString;
	//print json_encode($area_result);