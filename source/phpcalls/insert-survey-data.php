<?php

$jsondata = json_decode($_POST['to_json'], true);
$survey_id = $_REQUEST['survey_id'];

$dbh = new PDO('mysql:host=localhost;dbname=hsu_library;charset=utf8mb4', 'root', '');


foreach($jsondata as $key => $value){
	$furn_id = $value["furn_id"];
	$seat_type = $value["seat_type"];
	$num_seats = $value["num_seats"];

	if ($value["num_seats"] === 0) {
		$occupants = $value["totalOccupants"];
		$dbh->beginTransaction();
		$insert_room_stmt = $dbh->prepare('INSERT INTO surveyed_room (furniture_id, total_occupants, survey_id)
		                             	   VALUES (:furniture_id, :occupants, :survey_id)');
		$insert_room_stmt->bindParam(':furniture_id', $furn_id, PDO::PARAM_INT);
		$insert_room_stmt->bindParam(':occupants', $occupants, PDO::PARAM_INT);
		$insert_room_stmt->bindParam(':survey_id', $survey_id, PDO::PARAM_INT);
		$insert_room_stmt->execute();
		$dbh->commit();
	}
	else{
		if (array_key_exists('seat_places', $value)) {
			foreach ($value["seat_places"] as $key2 => $value2) {
				$occupied_state = $value2["occupied"];
				$seat_position = $value2["seatPos"];

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
			}
		}
	}
}

print json_encode($jsondata);