<?php
	//Get the furniture from a layout per the survey_id
	session_start();
	require_once('../config.php');
	//retrieve survey_id from ajax call.
	$survey_id =  $_REQUEST['survey_id'];
	$layout_id = $_REQUEST['layout_id'];
	
	//setup connection to DB
	$dbh = new PDO($dbhost, $dbh_select_user, $dbh_select_pw);
	

	//get all furniture
	$all_furn_stmt = $dbh->prepare('SELECT furniture_id, x_location, y_location, degree_offset,
										furniture_type, number_of_seats, in_area
									FROM furniture, furniture_type
									WHERE furniture_type = furniture_type_id
										AND layout_id = :layout_id');
									
	$all_furn_stmt->bindParam(':layout_id', $layout_id, PDO::PARAM_INT);
	
	$all_furn_stmt->execute();
	
	$all_furn = $all_furn_stmt->fetchAll();
	
	//return array
	$data = array();
	
	//iterate through all furniture and place in data array
	foreach($all_furn as $row){
		//get basic furniture items
		$fid = $row['furniture_id'];
		$x = $row['x_location'];
		$y = $row['y_location'];
		$degreeOffset = $row['degree_offset'];
		$ftype = $row['furniture_type'];
		$numSeats = $row['number_of_seats'];
		$inArea = $row['in_area'];
		$occupants = 0;
		
		//if this is a room, we want the total_occupants
		//might have to do a string compare
		if($numSeats === "0"){
			//get room occupants
			$roomOccupantStmt = $dbh->prepare("SELECT total_occupants 
												FROM surveyed_room
												WHERE furniture_id = :furniture_id
													AND survey_id = :survey_id");
			$roomOccupantStmt->bindParam(':furniture_id', $fid, PDO::PARAM_INT);										
			$roomOccupantStmt->bindParam(':survey_id', $survey_id, PDO::PARAM_INT);
			
			$roomOccupantStmt->execute();
			//place the total occupants in the room in the variable for the furniture
			$tempOcc = $roomOccupantStmt->fetchColumn();
			
			if($tempOcc > 0){
				$occupants = $tempOcc;
			}
			
		} else {
			//Since it's numSeats isn't 0, it isn't a room. Get seat information.
			//get count of occupied seats in furniture
			$occupied_furn_stmt = $dbh->prepare('SELECT count(*) occupied_seats
												FROM seat
												WHERE furniture_id = :furniture_id
													AND occupied = 1
													AND survey_id = :survey_id
													GROUP BY seat.furniture_id');
											
			$occupied_furn_stmt->bindParam(':furniture_id', $fid, PDO::PARAM_INT);
			$occupied_furn_stmt->bindParam(':survey_id', $survey_id, PDO::PARAM_INT);
			
			$occupied_furn_stmt->execute();
			
			$tempOcc = $occupied_furn_stmt->fetchColumn();
			
			//if the column returns a number, and it is greater than 0, overwrite occupants.
			if($tempOcc > 0){
				$occupants = $tempOcc;
			}
		}
		
		//get activities for the furniture
		$activity_stmt = $dbh->prepare('SELECT COUNT(activity_description), activity_description 
										FROM activity, seat_has_activity, seat
										WHERE furniture_id = :furniture_id
											AND seat.seat_id = seat_has_activity.seat_id
											AND seat_has_activity.activity_id = activity.activity_id
											AND survey_id = :survey_id
											GROUP BY activity_description');
											
		$activity_stmt->bindParam(':furniture_id', $fid, PDO::PARAM_INT);
		$activity_stmt->bindParam(':survey_id', $survey_id, PDO::PARAM_INT);
		
		$activity_stmt->execute();
		
		$activitiesQuery = $activity_stmt->fetchAll();
		
		//create an array to store activities
		$activities = array();
		foreach($activitiesQuery as $row){
			array_push($activities, array($row['COUNT(activity_description)'],$row['activity_description']));
		}
		
		
		//get modified furniture where it exists
		$mod_furn_stmt = $dbh->prepare('SELECT *
										FROM modified_furniture
										WHERE furniture_id = :furniture_id
											AND survey_id = :survey_id');
											
		$mod_furn_stmt->bindParam(':furniture_id', $fid, PDO::PARAM_INT);
		$mod_furn_stmt->bindParam(':survey_id', $survey_id, PDO::PARAM_INT);
		
		$mod_furn_stmt->execute();
		
		$mod_furn = $mod_furn_stmt->fetch(PDO::FETCH_BOTH);
		
		//save original x&y to show where mod furned moved from
		$original_x = $x;
		$original_y = $y;
		
		if($mod_furn_stmt->rowCount() > 0){
			$x = $mod_furn['new_x'];
			$y = $mod_furn['new_y'];
			$inArea = $mod_furn['in_area'];
		}
		
		//bind furniture elements to array
		$array_item = array( 'furniture_id' => $fid,
							  'num_seats' => $numSeats,
							  'x' => $x,
							  'y' => $y,
							  'degree_offset' => $degreeOffset,
							  'furn_type' => $ftype,
							  'in_area' => $inArea,
							  'occupants' => $occupants,
							  'activities' => $activities,
							  'original_x' => $original_x,
							  'original_y' => $original_y);
		array_push($data, $array_item);
	}
	
	
	print json_encode($data);
?>