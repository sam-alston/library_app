//Gets record information and sends queries for furniture and area which call populates to their maps.
function populateObjs(survey_id){
	$.ajax({
		url: 'phpcalls/record-from-survey.php',
		type: 'get',
		data:{ 'survey_id': survey_id },
		success: function(data){
			console.log("Retrieved survey record.");
			jsondata = JSON.parse(data);
			queryFurniture(survey_id,jsondata.layout);
			queryArea(jsondata.layout);
			
			loadMap(parseInt(jsondata.floor));
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) { 
			console.log("Status: " + textStatus);
			console.log("Error: " + errorThrown); 
		}     
	});
	
	
}

//query for furniture data
function queryFurniture(survey_id, layout_id){
	$.ajax({
		url: 'phpcalls/report-furniture-layout.php',
		type: 'get',
		data:{ 'survey_id': survey_id,
				'layout_id': layout_id},
		success: function(data){
			console.log("Retrieved survey record.");
			console.log(data);
			jsondata = JSON.parse(data);
			popFurnMap(jsondata);
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) { 
			console.log("Status: " + textStatus);
			console.log("Error: " + errorThrown); 
		}     
	});
}

//query for area data
function queryArea(layout_id){
	$.ajax({
		url: 'phpcalls/area-from-survey.php',
		type: 'get',
		data:{ 'layout_id': layout_id },
		success: function(data){
			console.log("Retrieved areas.");
			console.log(data);
			jsondata = JSON.parse(data);
			popAreaMap(jsondata);
			addSurveyedFurniture();
			addSurveyedAreas();
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) { 
			console.log("Status: " + textStatus);
			console.log("Error: " + errorThrown); 
		}     
	});
}

//populate the furnMap
function popFurnMap(jsonFurniture){
	for(key in jsonFurniture){
		
		furn = jsonFurniture[key];
		
		activities = [];
		jsonActivities = furn.activities;
		for(iter in jsonActivities){
			curAct = jsonActivities[iter];
			actCount = curAct[0];
			actName = curAct[1];
			tempAct = new Activity(actCount, actName);
			activities.push(tempAct);
		}
		cur_furn = new Furniture(furn.furniture_id,furn.num_seats, furn.x, furn.y, furn.degree_offset, furn.furn_type, furn.in_area, furn.occupants, activities);
		furnMap.set(furn.furniture_id, cur_furn);
	}
	
}

//populate the areaMap
function popAreaMap(jsonAreas){
	for(key in jsonAreas){
		cur_area = jsonAreas[key];
		
		verts = [];
		for(i in cur_area.area_vertices){
			cur_verts = cur_area.area_vertices[i];
			
			newVert = new Verts(cur_verts.v_x , cur_verts.v_y, cur_verts.load_order);
			verts.push(newVert);
		}
		
		newArea = new Area(cur_area.area_id, verts, cur_area.area_name);
		areaMap.set(cur_area.area_id, newArea);		
	}
}

//place floor map
function loadMap(floor){
	switch(floor){
		case 1:
			image = L.imageOverlay('images/floor1.svg', bounds).addTo(mymap);
			break;
		case 2:
			image = L.imageOverlay('images/floor2.svg', bounds).addTo(mymap);
			break;
		case 3: 
			image = L.imageOverlay('images/floor3.svg', bounds).addTo(mymap);
			break;
	}
	
}

//iterate through furnMap adding all furniture to mymap
function addSurveyedFurniture(){
	furnMap.forEach(function(key, value, map){
		
		latlng = [key.y, key.x];
		ftype = parseInt(key.ftype)
		selectedIcon = getIconObj(ftype);
		degreeOffset = parseInt(key.degreeOffset);
		numSeats = key.numSeats;
		occupied = key.occupants;
		fid = key.fid;
		areaId = key.inArea;
		activities = key.activities;
		
		//add occupants & numseats to area totals
		curArea = areaMap.get(areaId);
		curArea.occupants += parseInt(occupied);
		curArea.seats += parseInt(numSeats);
		
		marker = L.marker(latlng, {
			icon: selectedIcon,
			rotationAngle: degreeOffset,
						rotationOrigin: "center",
			draggable: false,
			ftype: ftype,
			numSeats: numSeats,
			fid: fid.toString()
		}).addTo(furnitureLayer);
		//initialize the popupString for a regular piece of furniture
		popupString = "Seats occupied: " + occupied + " of " + numSeats;
		
		//set oppacity to a ratio of the seat use, minimum of 0.3 for visibility
		oppacity = 0.3 + occupied/numSeats;
		//default oppacity for rooms is 0.5 or 1 for rooms that are occupied
		if(numSeats === "0"){
			popupString = "Room occupants: " + occupied;
			if(occupied > 0){
				oppacity = 1;
			} else {
				oppacity = 0.5
			}
		}
		//add activities and their count to the popupString
		for(i in activities){
			popupString += "</br>"+activities[i].count +"X: " + activities[i].name;
		}
		
		marker.bindPopup(popupString);
		marker.setOpacity(oppacity);
		marker.addTo(mymap);
	});	
}

//iterate through areaMap adding areas
function addSurveyedAreas(){
	areaMap.forEach(function(key, value, map){
		drawArea(key).addTo(mymap);
	});
}

//draw surveyed areas
function drawArea(area){
	var curVerts = [];
	
	for(var i=0; i < area.verts.length; i++){
		area_verts = area.verts[i];
		curVerts.push([area_verts.x,area_verts.y]);
	}
	var poly = L.polygon(curVerts);
	popupString = "<strong>"+area.area_name +"</strong></br>Total occupants: " + area.occupants + "/" + area.seats;
	poly.bindPopup(popupString);
	
	return poly;
}
