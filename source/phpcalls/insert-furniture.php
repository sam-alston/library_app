<?php
//insert the room occupants, seats, their activities and and any modified pieces of furniture
require_once('./../config.php');

$jsondata = json_decode($_POST['to_json'], true);
$layout_id = $_REQUEST['layout_id'];


//setup connection to DB
$dbh = new PDO($dbhost, $dbh_insert_user, $dbh_insert_pw);

//json data holds the furnMap, iterate through all pieces of furniture
foreach($jsondata as $key => $value){
	//get basic furniture data
	
	$x = $value['x'];
	$y = $value['y'];
	$degreeOffset = $value['degreeOffset'];
	$ftype = $value['ftype'];
	$inArea = $value['inArea'];
	
	$dbh->beginTransaction();
	$insert_furn_stmt = $dbh->prepare('INSERT INTO furniture 
	(x_location, y_location, degree_offset, layout_id, furniture_type, default_seat_type, in_area) 
	VALUES (:x, :y, :degreeOffset, :layout_id, :ftype, :default_seat_type, :inArea)');
						//(:x, :y, :degreeOffset, :layout_id, :ftype, :default_seat_type, :inArea)
	$insert_furn_stmt->bindParam(':x', $x, PDO::PARAM_INT);
	$insert_furn_stmt->bindParam(':y', $y, PDO::PARAM_INT);
	$insert_furn_stmt->bindParam(':degreeOffset', $degreeOffset, PDO::PARAM_INT);
	$insert_furn_stmt->bindParam(':layout_id', $layout_id, PDO::PARAM_INT);
	$insert_furn_stmt->bindParam(':ftype', $ftype, PDO::PARAM_INT);
	//currently, DB holds a def seat for objects, but we aren't tracking what they are.
	//32 is for a chair, later when library tracks we can replace this with chair data.
	$defSeat = 32;
	$insert_furn_stmt->bindParam(':default_seat_type', $defSeat, PDO::PARAM_INT);
	$insert_furn_stmt->bindParam(':inArea', $inArea, PDO::PARAM_INT);
	
	$insert_furn_stmt->execute();
	$dbh->commit();

}

print json_encode($insert_furn_stmt->rowCount());