	
function createAreas(layout){
	$.ajax({
	    url: 'phpcalls/area-select.php',
	    type: 'get',
	    data:{ 'layout_ID': layout },
	    success: function(data){
	        console.log("got area_IDs");
	        var json_object = JSON.parse(data);
	        
	        for(var i = 0; i < json_object.length; i++){
	            var obj = json_object[i];
	            area_id = obj['area_id'];
	            area_name = obj['name'];
	            //create area object, set to areaMap
	            cur_area = new Area(area_id, area_name);
	            areaMap.set(i, cur_area);
	        }
	        areaMap.forEach( function(item, key, mapObj){
	            $.ajax({
	                url: 'phpcalls/area-vertices-select.php',
	                type: 'get',
	                data:{ 'area_ID': item.area_id },
	                success: function(data){
	                    var vert_json_object = JSON.parse(data);
	                    
	                    for(var j = 0; j < vert_json_object.length; j++){
	                        var v_obj = vert_json_object[j];
	                        v_x = v_obj['v_x'];
	                        v_y = v_obj['v_y'];
	                        var cur_vert = new AreaVertices(v_x, v_y);
	                        item.area_vertices.push(cur_vert);
	                    }
	                    //draw area poly
	                    var polyArea = drawArea(item);
	                    item.polyArea = polyArea;
	                    polyArea.addTo(areaLayer);
	                }
	            }); 
	        });                     
	    }
	});
}


function Area(area_id, area_name){
    this.area_id = area_id;
    this.area_name = area_name;
    this.area_vertices = [];
    this.polyArea;
}

function AreaVertices(x,y){
    this.x = x;
    this.y = y;
}

function addAreas(){
    //draws the areas
    areaMap.forEach(function(item, key, mapObj){
        var polyArea = drawArea(item);
        polyArea.addTo(areaLayer);
    })
}

function drawArea(area){
	var verts = [];
	
	for(var i=0; i < area.area_vertices.length; i++){
		area_verts = area.area_vertices[i];
		verts.push([area_verts.x,area_verts.y]);
	}
	var poly = L.polygon(verts);
	poly.bindPopup(area.area_name);
	
	return poly;
}


function isMarkerInsidePolygon(x,y, poly) {
	var inside = false;
	//var x = marker.getLatLng().lat, y = marker.getLatLng().lng;
	for (var ii=0;ii<poly.getLatLngs().length;ii++){
		var polyPoints = poly.getLatLngs()[ii];
		for (var i = 0, j = polyPoints.length - 1; i < polyPoints.length; j = i++) {
			var xi = polyPoints[i].lat, yi = polyPoints[i].lng;
			var xj = polyPoints[j].lat, yj = polyPoints[j].lng;

			var intersect = ((yi > y) != (yj > y))
				&& (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
			if (intersect) inside = !inside;
		}
	}

	return inside;
}

