<?php
	//fetch the layout_id and floor by survey_id
	//prepare stmt to get layout_id from survey_id
	require_once('../config.php');
	
	$survey_id =  $_REQUEST['survey_id'];
	
	$dbh = new PDO($dbhost, $dbh_select_user, $dbh_select_pw);
	
	$record_stmt = $dbh->prepare("SELECT layout.layout_id cur_layout, floor 
								FROM survey_record, layout 
								WHERE survey_id = :survey_id
									AND survey_record.layout_id = layout.layout_id");
	$record_stmt->bindParam(':survey_id', $survey_id, PDO::PARAM_INT);
	//execute and retrieve
	$record_stmt->execute();
	//get the row from the query
	$record = $record_stmt->fetch(PDO::FETCH_BOTH);
	//place row in array
	$data = array("layout"=>$record[0],
				"floor"=>$record[1]);
	
	print json_encode($data);
?>