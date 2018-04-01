var RoundTableIcon = L.Icon.extend({
    options: {
		iconUrl: './images/icons/circ_table.svg',
        iconSize:     [38, 38],
        iconAnchor:   [19,19],
        popupAnchor:  [0, 0]
    }
});

var roundTable = new RoundTableIcon();

var CouchThreeIcon = L.Icon.extend({
	options: {
		iconUrl: './images/icons/couch_three.svg',
		iconSize: [38,38],
		iconAnchor: [19,19],
		popupAnchor: [0,0]
	}
});

var couchThree = new CouchThreeIcon();

var CouchFourIcon = L.Icon.extend({
	options: {
		iconUrl: './images/icons/couch_four.svg',
		iconSize: [38,38],
		iconAnchor: [19,19],
		popupAnchor: [0,0]
	}
});

var couchFour = new CouchFourIcon();

var ComputerStationIcon = L.Icon.extend({
	//this is called square_table in drive folder
	options: {
		iconUrl: './images/icons/square_table.svg',
		iconSize: [38,38],
		iconAnchor: [19,19],
		popupAnchor: [0,0]
	}
});

var computerStation = new ComputerStationIcon();
