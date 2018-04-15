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
                for(var j = 0; j < cur_furn.seat_places.length; j++){
                    var cur_seat = cur_furn.seat_places[j];
                     /* Run insert statment for each seat*/
                    $.ajax({
                        url: 'phpcalls/insert-seat.php',
                        type: 'post',
                        data:{
                            'furn_id': cur_furn.furn_id,
                            'occupied': cur_seat.occupied,
                            'seat_pos': cur_seat.seatPos,
                            'seat_type': cur_seat.type,
                            'survey_id': cur_survey_id
                        },
                        success: function(data){
                            console.log("Seat was inserted ");
=
                        }
                    });
                }
            }
            /*Send user to success page AFTER all ajax calls are completed*/
            /*WAIT FOR ALL AJAX CALLS TO COMPLETE*/
        }
    });  
};