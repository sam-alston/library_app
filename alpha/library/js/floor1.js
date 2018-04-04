//adds area polygons on floor one to the layer variable
function addFloorOneAreasTo(map, drawnItems){
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
		[75, 257],
		[75, 322],
		[189, 322],
		[189, 257]
	]);
	poly1.bindPopup("Main Lobby");
	polyLayers.push(poly1);
	
	var poly2 = L.polygon([
		[200, 258],
		[200, 291],
		[189, 297],
		[189, 315],
		[200, 323],
		[200, 356],
		[240, 356],
		[240, 258]
	]);
	poly2.bindPopup("Cafe");
	polyLayers.push(poly2);

	
	var poly3 = L.polygon([
		[269, 191],
		[338, 191],
		[338, 56],
		[269, 56]
	]);
	poly3.bindPopup("Learning Center and Tutoring Area");
	polyLayers.push(poly3);

	
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
	]);
	poly4.bindPopup("Computer Lab");
	polyLayers.push(poly4);
	
	// Add the layers to the drawnItems feature group 
    for(layer of polyLayers) {
        drawnItems.addLayer(layer); 
    }
}