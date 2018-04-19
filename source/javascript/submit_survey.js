/*This function is called when the survey is submitted and it populates the database with the appropriate seat objects*/

function submitSurvey(username, layout, furnMap){
    var cur_survey_id;
    console.log("You are submitting the survey");
    /* Insert statment for Survey ID */
    $.ajax({
        url: 'phpcalls/create_survey_record.php',
        type: 'get',
        data:{
            'username': username,
            'layout': layout,
            'survey_id': cur_survey_id
        },
        success: function(data){
            console.log("Inserted New Survey Record");
            /*Get that new Survey ID for insertion statements*/
            var json_object = JSON.parse(data);
            cur_survey_id = json_object.s_id;
            var iterateMap = furnMap.values();
            for(var i of furnMap){
                var cur_furn = iterateMap.next().value;
				//see if the furniture has been modified, if so insert
				if(cur_furn.modified){
					submitModified(cur_furn, cur_survey_id);
				}
				//check if the default number of seats is 0, then it's a room, else add seats
				if(cur_furn.num_seats === 0){
					$.ajax({
						url: 'phpcalls/insert-room.php',
						type: 'post',
						data:{
							'furn_id': cur_furn.furn_id,
							'occupants': cur_furn.totalOccupants,
							'survey_id': cur_survey_id
						},
						success: function(data){
							console.log("Room occupants inserted");
						}
					})
				} else {
					for(var j = 0; j < cur_furn.seat_places.length; j++){
						var cur_seat = cur_furn.seat_places[j];
						//make an int to pass to DB since they don't have boolean type
						var seatOccupied=0;
						if(cur_seat.occupied){
							seatOccupied = 1;
						}
						 /* Run insert statment for each seat*/
						$.ajax({
							url: 'phpcalls/insert-seat.php',
							type: 'post',
							data:{
								'furn_id': cur_furn.furn_id,
								'occupied': seatOccupied,
								'seat_pos': cur_seat.seatPos,
								'seat_type': cur_furn.seat_type,
								'survey_id': cur_survey_id
							},
							success: function(data){
								console.log("Seat was inserted ");
							}
						});
					}
				}
                
            }
            /*Send user to success page AFTER all ajax calls are completed*/
            /*WAIT FOR ALL AJAX CALLS TO COMPLETE*/
        }
    });  
};

function submitModified(cur_furn, survey_id) {
	$.ajax({
		url: 'phpcalls/insert-modified.php',
		type: 'post',
		data:{
			'furn_id': cur_furn.furn_id,
			'new_x': cur_furn.latlng.lng,
			'new_y': cur_furn.latlng.lat,
			'survey_id': survey_id,
			'in_area': cur_furn.in_area
		},
		success: function(data){
			console.log("Modified Furniture inserted");
		}
	});
}
