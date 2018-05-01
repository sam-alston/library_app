var mymap = L.map('mapid', {crs: L.CRS.Simple});
var areaLayer = L.layerGroup().addTo(mymap);
var furnitureLayer = L.layerGroup().addTo(mymap);
var bounds = [[0,0], [360,550]];

mymap.fitBounds(bounds);

var furnMap = new Map();
var activityMap = new Map();
var wb_activityMap = new Map();
var areaMap = new Map();

function getFurnMap(){
    return furnMap;
}

function getActivityMap(){
    return activityMap;
}

function getWhiteboardActivityMap(){
    return wb_activityMap;
}