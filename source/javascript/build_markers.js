//This function is called when the layout is set to properly build all of the furniture objects within the map
function build_markers(layout_id){
	$.ajax({
        url: 'phpcalls/get-furn.php',
        type: 'post',
        data:{ 'layout_id': layout_id },
        success: function(data){
            /*need to replace with ajax call getting actual layout id's*/

            console.log("got all furniture inside json array");
            var json_object = JSON.parse(data);

           
            for(var i in json_object){
            	var keystring = json_object[i];
				var furn_id;
				//get the value of the furniture id
            	for(var i in keystring){
					furn_id = i;
				}
            	var num_seats = keystring.num_seats;
                var newFurniture = new Furniture( keystring, num_seats);
         
            	var x = keystring[furn_id].x;
            	var y = keystring[furn_id].y;
            	var degree_offset = keystring[furn_id].degree_offset;
            	var furniture_type = keystring[furn_id].furn_type;
            	var default_seat_type = keystring[furn_id].default_seat_type;
            	
            	var latlng = [y,x];
                var selectedIcon;

                newFurniture.degreeOffset = degree_offset;					

				area_id="TBD";
				newFurniture.y = y;
				newFurniture.x = x;

				var type = parseInt(furniture_type);
				switch(type){
					case 1:
                    case 2:
                    case 3:
                    case 4: selectedIcon=rectTable ; break;
                    case 5:
                    case 6: selectedIcon=counterCurved; break;
                    case 7:
                    case 8:
                    case 9:
                    case 10: selectedIcon=circTable; break;
					case 11: selectedIcon=couchCurved ; break;
					case 12: selectedIcon=couchTwo ; break;
                    case 13: selectedIcon=couchThree ; break;
					case 14: selectedIcon=couchFour; break;
                    case 15: selectedIcon=couchSix ; break;
                    case 16:
                    case 17:
                    case 18:
                    case 19: selectedIcon=collabStation; break;
                    case 20: selectedIcon=roomIcon; break;
					case 21: selectedIcon=computerStation;break;
					case 22: selectedIcon= seatOne; break;
                    case 23: selectedIcon= seatOneSoft; break;
                    case 24: selectedIcon= fitDeskEmpty; break;
                    case 25: selectedIcon= medCornerEmpty; break;
					case 26: selectedIcon= mfReaderEmpty; break;
                    case 27: selectedIcon= studyOne; break;
                    case 28: selectedIcon= studyTwo; break;
					case 29: selectedIcon= studyThree; break;
					case 30: selectedIcon= studyFour; break;
					case 31: selectedIcon= vidViewerEmpty; break;
					case 33: selectedIcon=rectTable ; break;
                    default: selectedIcon= computerStation; break;
                }

                //place a marker for each furniture item
                marker = L.marker(latlng, {
                    icon: selectedIcon,
                    rotationAngle: degree_offset,
				            	rotationOrigin: "center",
                    draggable: false,
                    ftype: furniture_type,
                    numSeats: num_seats,
                    fid: furn_id.toString()
                }).addTo(furnitureLayer).bindPopup(popup, popupDim);

                marker.on('click', markerClick);
				marker.setOpacity(.3);
					
				//update marker coords in marker map on dragend, set to modified
				marker.on("dragend", function(e){
					selected_furn.modified = true;
					latlng =  e.target.getLatLng();

                    selected_furn.latlng = latlng;
                    y = latlng.lat;
                    x = latlng.lng;
                    area_id="TBD";
                    selected_furn.y = y;
                    selected_furn.x = x;
                    areaMap.forEach(function(jtem, key, mapObj){
                        
                        if(isMarkerInsidePolygon(y,x, jtem.polyArea)){
                            area_id = jtem.area_id;
                        }
                    });
                    if(area_id !== "TBD"){
                        selected_furn.in_area = area_id;
                    }
                    console.log("area_id: "+area_id);
                    console.log("x: "+x+"\ny: "+y);

				});
				furnMap.set(furn_id.toString(), newFurniture);
            }
        }
    });

}