//adds area polygons on floor three to the mymap variable
function floorThreeAreas(mymap){
	var polygon1 = L.polygon([
		[61, 61],
		[61, 204],
		[75, 204],
		[75, 75],
		[298, 75],
		[298, 170],
		[312, 170],
		[312,61]
	]).addTo(mymap);
	polygon1.bindPopup("Quiet Area");
	
	var poly2 = L.polygon([
		[167,277],
		[60,276],
		[60,298],
		[141,298],
		[141,468],
		[97,468],
		[97,494],
		[167,494]
	]).addTo(mymap);
	poly2.bindPopup("Scholars Runway");
	
	var poly3 = L.polygon([
		[60,298],
		[141,298],
		[141,421],
		[60,421]
	]).addTo(mymap);
	poly3.bindPopup("Special Collections");
	
	var poly4 = L.polygon([
		[167,277],
		[167,400],
		[194,400],
		[194,385],
		[209,385],
		[209,277]
	]).addTo(mymap);
	poly4.bindPopup("Scholars Lab");
	
	var poly5 = L.polygon([
		[171, 240],
		[171, 75],
		[197, 75],
		[197, 215],
		[250, 215],
		[250, 170],
		[276, 170],
		[276, 240]
	]).addTo(mymap);
	poly5.bindPopup("Social Group Study");
}