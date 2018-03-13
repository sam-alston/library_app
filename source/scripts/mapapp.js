var submit = document.getElementById("sub_layout");
var floor_image = "local";
var s_layout = "local";
var mymap = L.map('mapid', {crs: L.CRS.Simple});
var bounds = [[0,0], [360,550]];
var image;
mymap.fitBounds(bounds);


submit.onclick = function(){
	if( mymap.hasLayer(image)){
		mymap.removeLayer(image);
	}
	var form_info = document.getElementById("lay-select");
	var test =  document.getElementById("text");
	floor_image = form_info.elements["floor-select"].value;
	s_layout = form_info.elements["layout-select"].value;
	test.innerHTML = floor_image;
	image = L.imageOverlay('../LibraryAppTest/images/' + String(floor_image), bounds).addTo(mymap);

	var sol = L.latLng([ 180, 275]);
	L.marker(sol).addTo(mymap);
	map.setView( [180, 275], 1);
}
//make jsobjects and structure that stores the objects

//furniture object constructor
/*
var furn = {
	num-seats: '',
	x-corr: '',
	y-corr: '',
	type: '',
	whiteboard: '',
	seat-places[] //dynamic array of seat objects
};

var x = furn;
var y = furn;
var z = furn;
x.x-corr = 64;
y.x-corr = 65;


//seat object constructor
var seat = {
	occupied: 'False',
	social: 'False',
	study: 'False',
	tech: 'False'
};

//instantiate map of furniture objects
var furnMap = new Map()
*/
//parse the .pdo file into the map
/*
	while(file = open){
		var f_id = '';
		var x = '';
		var y = '';
		type = '';
		whiteboard = '';
		myMap.set('f_id', f_id + String(type){define variables of object in here});
		set array after that
	}
*/