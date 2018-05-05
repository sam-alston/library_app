<?php
	//Get area_ids and their vertices from layout_id
	session_start();
	require_once('./../config.php');

	$layout_id =  $_REQUEST['layout_id'];

	$dbh = new PDO($dbhost, $dbh_select_user, $dbh_select_pw);

	
	

	//get area_ids from layout
	$area_in_layout_stmt = $dbh->prepare('SELECT area.area_id id, area.name name
										FROM area_in_layout , area
										WHERE area.area_id = area_in_layout.area_id
											AND layout_id = :layout_id');

	$area_in_layout_stmt->bindParam(':layout_id', $layout_id, PDO::PARAM_INT);
	$area_in_layout_stmt->execute();
	
	$area_ids = $area_in_layout_stmt->fetchAll();
	
	
	//create array to return
	$data = array();
	
	//iterate through all area_ids to get vertices
	foreach($area_ids as $row){
		$cur_area_id = $row['id'];
		$cur_area_name = $row['name'];
		
		$area_verts_stmt = $dbh->prepare('SELECT * 
										FROM area_vertices
										WHERE area_id = :area_id
										ORDER BY load_order');
										
		$area_verts_stmt->bindParam(':area_id', $cur_area_id, PDO::PARAM_INT);
		
		$area_verts_stmt->execute();
		
		$area_verts = $area_verts_stmt->fetchAll();
		
		//create array for vertices
		$vertices_array = array();
		
		//iterate through each area vertice row
		foreach($area_verts as $vert_row){
			//get vertice variables
			$cur_v_x = $vert_row['v_x'];
			$cur_v_y = $vert_row['v_y'];
			$cur_load_order = $vert_row['load_order'];
			
			$v_array = array( 'v_x' => $cur_v_x,
								'v_y' => $cur_v_y,
								'load_order' => $cur_load_order);
			
			array_push($vertices_array, $v_array);
		}
		$cur_area = array("area_id"=>$cur_area_id,
							"area_name"=>$cur_area_name,
							"area_vertices"=>$vertices_array);
		//$cur_area = array($cur_area_id=>$vertices_array);
		
		array_push($data, $cur_area);
	}
	//return data containing areas
	print json_encode($data);

?>