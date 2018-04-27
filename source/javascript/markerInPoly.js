//determine if a point defined by x,y is inside a polygon called poly
//returns true if inside, else false
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
};