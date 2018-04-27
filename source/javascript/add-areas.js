//This file defines all classes and functions to pull areas from DB, store in objects, and draw polygons of areas.

//Call to createAreas takes a layout, looksup all areas in that layout.
//Calls area-select.php to get areas from DB. 
//	Create area object, then set to areaMap.
//Calls area-vertices-select.php to get vertices of each area from DB.
//	Creates areaVertices and pushes to current area object.
//Once all areas have been created add to areaLayer (attached to mymap)

function createAreas(layout){
	$.ajax({
	    url: 'phpcalls/area-select.php',
	    type: 'get',
	    data:{ 'layout_ID': layout },
	    success: function(data){
	        console.log("got area_IDs");
	        var json_object = JSON.parse(data);

	        //iterate through all area_id's
	        for(var i = 0; i < json_object.length; i++){
	            var obj = json_object[i];
	            area_id = obj['area_id'];
	            area_name = obj['name'];
	            //create area object, set to areaMap
	            cur_area = new Area(area_id, area_name);
	            areaMap.set(i, cur_area);
	        }

			//for each area, get its areaVertices
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

	                    //draw area polys and add to areaLayer
	                    var polyArea = drawArea(item);
	                    item.polyArea = polyArea;
	                    polyArea.addTo(areaLayer);
	                }
	            }); 
	        });                     
	    }
	});
}

//define Area class.
//Take in the area_id, and area_name to set to the object at creation
function Area(area_id, area_name){
    this.area_id = area_id;
    this.area_name = area_name;
    this.area_vertices = [];
    this.polyArea;
}

//define AreaVertices, a class that is a member of Area
//areaVertices are a two-tuple array.
function AreaVertices(x,y){
    this.x = x;
    this.y = y;
}

//iterate over areaMap calling drawArea for each member of the map.
//catch the polygon returned by drawArea, add to areaLayer (which is attached to mymap).
//currently: UNUSED
function addAreas(){
    //draws the areas
    areaMap.forEach(function(item, key, mapObj){
        var polyArea = drawArea(item);
        polyArea.addTo(areaLayer);
    })
}

//take an Area object and draw a polygon with Area's area_vertices member
//takes an Area object, returns a polygon of that area.
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

//determine if a point defined by x,y is inside a polygon called poly
//return true if point is in poly, else return false
function isMarkerInsidePolygon(x,y, poly) {
	var inside = false;
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

