/*This function is called when the layout is submitted and it populates the database with the appropriate furniture objects*/
function submitLayout(username, floor, furnMap, areaMap){
    
    console.log("You are submitting the layout");

    $(".loading").addClass("loadingapply");
    $("#load-image").addClass("imagerotate");

    $.ajax({
        url: 'phpcalls/create-layout.php',
        type: 'get',
        data:{
            'username': username,
            'floor': floor
        },
        success: function(data){
            console.log(data);
            /*Get that new layout ID for insertion statements*/
            var json_object = JSON.parse(data);
            layout_id = json_object.layout_id;
			
			
			
			//prep furnMap to insert
            var objmap = mapToObj(furnMap);
            var json_string = JSON.stringify(objmap);
			
            console.log(json_string);
            $.ajax({
				url: 'phpcalls/insert-furniture.php',
				type: 'post',
				data:{
					'layout_id': layout_id,
					'to_json': json_string
				},
				success: function(data){
					var used_json = data;
					if(data > 0){
			
			/*now insert areas to area_in_layout
			var aobjmap = mapToObj(areaMap);
            var ajson_string = JSON.stringify(aobjmap);
			$.ajax({
				url: 'phpcalls/insert-area-in-layout.php',
				type: 'post',
				data:{
					'layout_id': layout_id,
					'to_json': ajson_string
				},
				success: function(data){
					var used_json = data;
					if(data > 0){
					
						alert("Success!");
					} else {
						alert("Something went wrong.");
						console.log(data);
					}
					window.location.href = 'layout-success.php';
				}
			});*/
						
						
						
						
					} else {
						alert("Something went wrong.");
						console.log(data);
					}
					window.location.href = 'layout-success.php';
				}
			});
			
        }, error: function(xhr, status, error) {
		  console.log(xhr.responseText);
		}
		
    });
}

//takes a furnMap and returns it as an object array
function mapToObj(inputMap) {
    var obj = {};

    inputMap.forEach(function(value, key){
        obj[key] = value
    });

    return obj;
}

