//places activities in an activityMap
//TODO: add field for wb_activity column
$(window).on("load", function(){
	$.ajax({
        url: 'phpcalls/get-activities.php',
        type: 'get',
        data:{},
        success: function(data){
            /*need to replace with ajax call getting actual layout id's*/
            console.log("got activities");
            var json_object = JSON.parse(data);
            for(var i = 0; i < json_object.length; i++){
            	var obj = json_object[i];
            	var activity_id = obj['activity_id'];
                var description = obj['activity_description'];
                activityMap.set(activity_id, description);
            }
        }
    });
});