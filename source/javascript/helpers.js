function minusHelper(){
    minus(selected_furn);
}

function plusHelper(){
	//selected_furn.seat_places.push(new Seat(selected_furn.seat_places.length));
	var newSeat = new Seat(temp_seat_places.length);
    temp_seat_places.push(newSeat);
	//plus(selected_furn, selected_furn.seat_places.length);
	//pass true for occupied because we are adding another seat to the default
	plus(newSeat, temp_seat_places.length, true);
	checkAll(selected_furn);
}

function saveHelper(){
	var occupants = document.getElementById("occupantInput");
	if(occupants)
	{
		selected_furn.totalOccupants = occupants.value;
	}
	selected_marker.setOpacity(1);
	selected_furn.seat_places = temp_seat_places;
	
	if(temp_wb != [])
	{
		selected_furn.whiteboard = temp_wb;
	}
	
  	mymap.closePopup();
}

function lockHelper(){
	var lockButton = document.getElementById("lock");
	
	if(lockButton.innerText === "Unlock")
	{
		selected_marker.dragging.enable();
		lockButton.innerText = "Lock";
	}        	
	else
	{
		selected_marker.dragging.disable();
		lockButton.innerText = "Unlock";
	}
	mymap.closePopup();
}

function checkAllHelper(){
	checkAll(selected_furn);
}

//rotate selected furniture
//pass the div to append to
function rotateHelper(parentDiv)
{
	if(document.getElementById("rotateSlider") == null)
	{
		var rotateSlider = document.createElement("input");
		rotateSlider.type = "range";
		rotateSlider.min = "-180";
		rotateSlider.max = "180";
		rotateSlider.value = "0";
		rotateSlider.step = "10";
		rotateSlider.id = "rotateSlider";
		rotateSlider.value = selected_furn.degreeOffset;
		
		var sliderValue = document.createElement("p");
		sliderValue.id = "sliderValue";
		sliderValue.innerText = "Value: "+selected_furn.degreeOffset;
		
		document.getElementById(parentDiv).appendChild(sliderValue);
		document.getElementById(parentDiv).appendChild(rotateSlider);
	
			
		rotateSlider.oninput = function()
		{
			selected_marker.setRotationOrigin("center");
			selected_furn.degreeOffset =rotateSlider.value;
			selected_marker.options.degree_offset = rotateSlider.value;
			selected_marker.setRotationAngle(rotateSlider.value);
			sliderValue.innerText = "Value: " + rotateSlider.value;
		}
	}
	
	else
	{
		document.getElementById("rotateSlider").remove();
		document.getElementById("sliderValue").remove();
	}

}


//this helper will iterate over furnmap and provide update statements for all furnitures location.
function updateHelper(){
	var outString="";
	
	furnMap.forEach(function(item, key, mapObj){
		aid = "TBD";
		x = item.x;
		y = item.y;
		areaMap.forEach(function(jtem, jkey, mapObj){
				
			if(isMarkerInsidePolygon(y,x, jtem.polyArea)){
				aid = jtem.area_id;
			}
		});
		if(area_id !== "TBD"){
			item.in_area = aid;
		}
        outString+= updateFurn(item);
		outString+="\n";
	});
	console.log(outString);
}

//On click of submission, Create's a Survey Record and Inserts each seat object into the database with that ID
function submitSurveyHelper(){
    submitSurvey(username, layout, furnMap);
}

//deletes the selected marker
function deleteHelper()
{
	//remove marker
	mymap.removeLayer(selected_marker);
	//remove furniture from furnMap
	furnMap.delete(selected_furn.id);
}