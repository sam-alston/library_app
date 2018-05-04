<?php
//insert the room occupants, seats, their activities and and any modified pieces of furniture
require_once('./../config.php');

$jsondata = json_decode($_POST['to_json'], true);
$survey_id = $_REQUEST['survey_id'];

//setup connection to DB
$dbh = new PDO($dbhost, $dbh_insert_user, $dbh_insert_pw);

//json data holds the furnMap, iterate through all pieces of furniture
foreach($jsondata as $key => $value){
	//get basic furniture data
	$furn_id = $value["furn_id"];
	$seat_type = $value["seat_type"];
	$num_seats = $value["num_seats"];
	$modified = $value["modified"];

	//debug retstring
	$retString;
	
	//if the furniture has been modified, add a modified_furniture entry
	if($modified){
		//get new location of furniture
		$new_x = $value["x"];
		$new_y = $value["y"];
		$degree_offset = $value["degreeOffset"];
		$in_area = $value["in_area"];

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
	}

	//if num_seats is zero, this is a room and will have to add total occupants to surveyed_room
	if ($value["num_seats"] === 0) {
		//get total occupants of room
		$occupants = $value["totalOccupants"];
		
		$dbh->beginTransaction();
		$insert_room_stmt = $dbh->prepare('INSERT INTO surveyed_room (furniture_id, total_occupants, survey_id)
		                             	   VALUES (:furniture_id, :occupants, :survey_id)');
										   
		$insert_room_stmt->bindParam(':furniture_id', $furn_id, PDO::PARAM_INT);
		$insert_room_stmt->bindParam(':occupants', $occupants, PDO::PARAM_INT);
		$insert_room_stmt->bindParam(':survey_id', $survey_id, PDO::PARAM_INT);
		
		$insert_room_stmt->execute();
		$retString = $insert_room_stmt;
		$dbh->commit();
	}
  
	//if seat_places exists, we enter each seat to the database. A room will have a seat when it has activities.
	if (array_key_exists('seat_places', $value)) {
		foreach ($value['seat_places'] as $key2 => $value2) {
			$occupied_state=0;
			if($value2['occupied']){
				$occupied_state = 1;
			}
			$seat_position = $value2['seatPos'];
			
			$dbh->beginTransaction();
			$insert_seat_stmt = $dbh->prepare('INSERT INTO seat (furniture_id, occupied, seat_position, seat_type, survey_id)
											   VALUES (:furniture_id, :occupied, :seat_pos, :seat_type, :survey_id)');

			$insert_seat_stmt->bindParam(':furniture_id', $furn_id, PDO::PARAM_INT);
			$insert_seat_stmt->bindParam(':occupied', $occupied_state, PDO::PARAM_INT);
			$insert_seat_stmt->bindParam(':seat_pos', $seat_position, PDO::PARAM_INT);
			$insert_seat_stmt->bindParam(':seat_type', $seat_type, PDO::PARAM_INT);
			$insert_seat_stmt->bindParam(':survey_id', $survey_id, PDO::PARAM_INT);
			$insert_seat_stmt->execute();
			$seat_id = $dbh->lastInsertId();
			$dbh->commit();
			
			//if there are activities in the seat, they must also be added
			if(array_key_exists('activity', $value2)){
				//there can be multiple activities for each seat, so we add all in the array
				foreach ($value2["activity"] as $actKey => $actVal){
					//the actVal is the activity description
					//create a new pdo to select so it has permission
					$dbh_select = new PDO($dbhost, $dbh_select_user, $dbh_select_pw);
					$get_act_id_stmt = $dbh_select->prepare('SELECT activity_id FROM activity WHERE activity_description = :activity');
					$get_act_id_stmt->bindParam(':activity', $actVal, PDO::PARAM_STR);
					
					$get_act_id_stmt->execute();
					
					$activity = $get_act_id_stmt->fetchColumn();
					
					$dbh->beginTransaction();
					$insert_seat_act_stmt = $dbh->prepare('INSERT INTO seat_has_activity (seat_id, activity_id)
													VALUES (:seat_id, :activity_id)');
													
					$insert_seat_act_stmt->bindParam(':seat_id', $seat_id, PDO::PARAM_INT);
					$insert_seat_act_stmt->bindParam(':activity_id', $activity, PDO::PARAM_INT);
					
					$insert_seat_act_stmt->execute();
					$dbh->commit();
				}
			}
		}
	}
}

print json_encode($insert_seat_stmt->rowCount());
//print $retString;