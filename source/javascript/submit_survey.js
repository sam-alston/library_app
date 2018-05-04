/*This function is called when the survey is submitted and it populates the database with the appropriate seat objects*/
function submitSurvey(username, layout, furnMap){
    var cur_survey_id;
    console.log("You are submitting the survey");
    /* Insert statment for Survey ID */

    $(".loading").addClass("loadingapply");
    $("#load-image").addClass("imagerotate");

    $.ajax({
        url: 'phpcalls/create_survey_record.php',
        type: 'get',
        data:{
            'username': username,
            'layout': layout
        },
        success: function(data){
            console.log(data);
            /*Get that new Survey ID for insertion statements*/
            var json_object = JSON.parse(data);
            cur_survey_id = json_object.survey_id;
            var iterateMap = furnMap.values();
            for(var i of furnMap){
            	var cur_furn = iterateMap.next().value;

            	if(cur_furn.modified===true){
					//submitModified(cur_furn, cur_survey_id);
					cur_furn.furn_id;
				}

            	if(cur_furn.seat_places.length === 0 && cur_furn.num_seats != 0){
					//add the empty seats
					for( var k = 0; k < cur_furn.num_seats; k++){
						cur_furn.seat_places.push(new Seat(k));
					}
				}
            }

            var objmap = mapToObj(furnMap);
            var json_string = JSON.stringify(objmap);
            console.log(json_string);
            $.ajax({
				url: 'phpcalls/insert-survey-data.php',
				type: 'post',
				data:{
					'survey_id': cur_survey_id,
					'to_json': json_string
				},
				success: function(data){
					
					console.log(data);
					if(data>0){
						window.location.href = 'survey-success.php';
					} else {
						alert("An error occured, please try again.");
					}
				}
			});
        }
    });
};

//takes a furnMap and returns it as an object array
function mapToObj(inputMap) {
    var obj = {};

    inputMap.forEach(function(value, key){
        obj[key] = value
    });

    return obj;
}

