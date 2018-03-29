//adds area polygons on floor two to the mymap variable
function floorTwoAreas(mymap){
	var poly1 = L.polygon([
		[101, 61],
		[101, 94],
		[105.5, 94],
		[105.5, 126.5],
		[101, 126.5],
		[101, 159.2],
		[105.5, 159.2],
		[105.5, 191],
		[115, 191],
		[115, 75],
		[319, 75],
		[319, 191],
		[334, 191],
		[334, 159.2],
		[339, 159.2],
		[339, 126.6],
		[334, 126.6],
		[334, 57],
		[301.5, 57],
		[301.5, 61.3],
		[268.9, 61.3],
		[268.9, 57],
		[236.2, 57],
		[236.2, 61.3],
		[203.4, 61.3],
		[203.4, 57],
		[170.7, 57],
		[170.7, 61]
	]).addTo(mymap);
	poly1.bindPopup("Quiet Study Area");
	var poly2 = L.polygon([
		[206, 191],
		[206, 223],
		[302, 223],
		[302, 229],
		[333, 229],
		[333, 224],
		[338, 224],
		[338, 191]
	]).addTo(mymap);
	poly2.bindPopup("SW Group Study");
	
	var poly3 = L.polygon([
		[205, 349],
		[240, 349],
		[240, 257],
		[205, 257]
	]).addTo(mymap);
	poly3.bindPopup("West Window Group Study Area");
	
	var poly4 = L.polygon([
		[205, 257],
		[191, 257],
		[191, 354],
		[205, 354]
	]).addTo(mymap);
	poly4.bindPopup("Collaboration Lab");
	
	var poly5 = L.polygon([
		[191, 265],
		[152, 265],
		[152, 440],
		[191, 440]
	]).addTo(mymap);
	poly5.bindPopup("Whiteboard Group Study Area");
	
	var poly6 = L.polygon([
		[281, 454],
		[281, 484],
		[286, 484],
		[286, 497],
		[280, 497],
		[280, 502],
		[268, 502],
		[268, 497],
		[236, 497],
		[236, 502],
		[203, 502],
		[203, 454]
	]).addTo(mymap);
	poly6.bindPopup("Children's Literature Group Study");
	
	var poly7 = L.polygon([
		[60, 497],
		[60, 502],
		[203, 502],
		[203, 461],
		[96, 461]
	]).addTo(mymap);
	poly7.bindPopup("Helen Everett Reading Room Group Study Area");
	
	var poly8 = L.polygon([
		[60, 497],
		[55, 497],
		[55, 258],
		[104, 258],
		[104, 443],
		[96, 443],
		[96, 461]
	]).addTo(mymap);
	poly8.bindPopup("HSU Authors Hall Group Study");
}