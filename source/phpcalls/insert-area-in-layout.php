<?php
//insert the areas in the area_in_layout table
require_once('./../config.php');

$jsondata = json_decode($_POST['to_json'], true);
$layout_id = $_REQUEST['layout_id'];


//setup connection to DB
$dbh = new PDO($dbhost, $dbh_insert_user, $dbh_insert_pw);

//json data holds the furnMap, iterate through all pieces of furniture
foreach($jsondata as $key => $value){
	//get basic furniture data
	
	$area_id = $value['area_id'];
	
	$dbh->beginTransaction();
	$insert_lia_stmt = $dbh->prepare('INSERT INTO area_in_layout 
								(area_id, layout_id)
								VALUES (:area_id, :layout_id)');
						
	$insert_lia_stmt->bindParam(':area_id', $area_id, PDO::PARAM_INT);
	$insert_lia_stmt->bindParam(':layout_id', $layout_id, PDO::PARAM_INT);
	
	
	$insert_lia_stmt->execute();
	$dbh->commit();

}

print json_encode($insert_lia_stmt->rowCount());