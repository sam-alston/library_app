//adds area polygons on floor two to the layer variable
function addFloorTwoAreasTo(map, drawnItems){
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
	]);
	poly1.bindPopup("Quiet Study Area");
	polyLayers.push(poly1);
	
	var poly2 = L.polygon([
		[206, 191],
		[206, 223],
		[302, 223],
		[302, 229],
		[333, 229],
		[333, 224],
		[338, 224],
		[338, 191]
	]);
	poly2.bindPopup("SW Group Study");
	polyLayers.push(poly2);
	
	var poly3 = L.polygon([
		[205, 349],
		[240, 349],
		[240, 257],
		[205, 257]
	]);
	poly3.bindPopup("West Window Group Study Area");
	polyLayers.push(poly3);
	
	var poly4 = L.polygon([
		[205, 257],
		[191, 257],
		[191, 354],
		[205, 354]
	]);
	poly4.bindPopup("Collaboration Lab");
	polyLayers.push(poly4);
	
	var poly5 = L.polygon([
		[191, 265],
		[152, 265],
		[152, 440],
		[191, 440]
	]);
	poly5.bindPopup("Whiteboard Group Study Area");
	polyLayers.push(poly5);
	
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
	]);
	poly6.bindPopup("Children's Literature Group Study");
	polyLayers.push(poly6);
	
	var poly7 = L.polygon([
		[60, 497],
		[60, 502],
		[203, 502],
		[203, 461],
		[96, 461]
	]);
	poly7.bindPopup("Helen Everett Reading Room Group Study Area");
	polyLayers.push(poly7);
	
	var poly8 = L.polygon([
		[60, 497],
		[55, 497],
		[55, 258],
		[104, 258],
		[104, 443],
		[96, 443],
		[96, 461]
	]);
	poly8.bindPopup("HSU Authors Hall Group Study");
	polyLayers.push(poly8);
	
	// Add the layers to the drawnItems feature group 
    for(layer of polyLayers) {
        drawnItems.addLayer(layer); 
    }
}