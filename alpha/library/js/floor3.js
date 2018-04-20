//adds area polygons on floor three to the layer variable
function addFloorThreeAreasTo(map, drawnItems){
    if(map.hasLayer(drawnItems)){
    drawnItems.eachLayer(
        function(l){
            drawnItems.removeLayer(l);
    });
	} else {
		mymap.addLayer(drawnItems);
	}
    var polyLayers = [];
	
	var poly1 = L.polygon([
		[61, 61],
		[61, 204],
		[75, 204],
		[75, 75],
		[298, 75],
		[298, 170],
		[312, 170],
		[312,61]
	]);
	poly1.bindPopup("Quiet Area");
	polyLayers.push(poly1);
	
	var poly2 = L.polygon([
		[167,277],
		[60,276],
		[60,298],
		[141,298],
		[141,468],
		[97,468],
		[97,494],
		[167,494]
	]);
	poly2.bindPopup("Scholars Runway");
	polyLayers.push(poly2);
	
	var poly3 = L.polygon([
		[60,298],
		[141,298],
		[141,421],
		[60,421]
	]);
	poly3.bindPopup("Special Collections");
	polyLayers.push(poly3);
	
	var poly4 = L.polygon([
		[167,277],
		[167,400],
		[194,400],
		[194,385],
		[209,385],
		[209,277]
	]);
	poly4.bindPopup("Scholars Lab");
	polyLayers.push(poly4);
	
	var poly5 = L.polygon([
		[171, 240],
		[171, 75],
		[197, 75],
		[197, 215],
		[250, 215],
		[250, 170],
		[276, 170],
		[276, 240]
	]);
	poly5.bindPopup("Social Group Study");
	polyLayers.push(poly5);
	
	// Add the layers to the drawnItems feature group 
    for(layer of polyLayers) {
        drawnItems.addLayer(layer); 
    }
}