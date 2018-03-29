//adds area polygons on floor one to the mymap variable
function floorOneAreas(mymap){
	var poly1 = L.polygon([
		[75, 257],
		[75, 322],
		[189, 322],
		[189, 257]
	]).addTo(mymap);
	poly1.bindPopup("Main Lobby");

	
	var poly2 = L.polygon([
		[200, 258],
		[200, 291],
		[189, 297],
		[189, 315],
		[200, 323],
		[200, 356],
		[240, 356],
		[240, 258]
	]).addTo(mymap);
	poly2.bindPopup("Cafe");
	
	var poly3 = L.polygon([
		[269, 191],
		[338, 191],
		[338, 56],
		[269, 56]
	]).addTo(mymap);
	poly3.bindPopup("Learning Center and Tutoring Area");
	
	var poly4 = L.polygon([
		[170, 126],
		[140, 126],
		[140, 192],
		[205, 192],
		[205,258],
		[235, 258],
		[235, 224],
		[269, 224],
		[269, 56],
		[170, 56]
	]).addTo(mymap);
	poly4.bindPopup("Computer Lab");
}