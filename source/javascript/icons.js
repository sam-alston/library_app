//extend the marker class to add furniture data
var marker = L.Marker.extend({
	options: {
		fid: 0,
		ftype: "default ftype",
		degreeOffset: 0,
		numSeats: 0,
		defaultSeat: "default seat"
	}
});

//extend Icon for each different furniture icon
var CircTableIcon = L.Icon.extend({
    options: {
		className: 'furnitureLargeIcon',
		iconUrl: './images/icons/circ_table.svg',
        iconSize:     [38, 38],
        iconAnchor:   [19,19],
        popupAnchor:  [0, 0]
    }
});

var circTable = new CircTableIcon();

var CouchThreeIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/couch_three.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var couchThree = new CouchThreeIcon();

var CouchFourIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/couch_four.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var couchFour = new CouchFourIcon();

var ComputerStationIcon = L.Icon.extend({
	//this is called square_table in drive folder
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/square_table.svg',
		iconSize: [80,80],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var computerStation = new ComputerStationIcon();

var CollabStationIcon = L.Icon.extend({
	options: {
		className: 'furnitureLargeIcon',
		rotationAngle: 180,
		iconUrl: './images/icons/collab_station.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var collabStation = new CollabStationIcon();

var CouchCurvedIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/couch_curved.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var couchCurved = new CouchCurvedIcon();

var CouchSixIcon = L.Icon.extend({
	options: {
		className: 'furnitureLargeIcon',
		iconUrl: './images/icons/couch_six.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var couchSix = new CouchSixIcon();

var CouchTwoIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/couch_two.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var couchTwo = new CouchTwoIcon();

var CounterCurvedIcon = L.Icon.extend({
	options: {
		className: 'furnitureLargeIcon',
		iconUrl: './images/icons/counter_curved.png',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var counterCurved = new CounterCurvedIcon();

var FitDeskEmptyIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/fit_desk_empty.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var fitDeskEmpty = new FitDeskEmptyIcon();

var FitDeskFilledIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/fit_desk_filled.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var fitDeskFilled = new FitDeskFilledIcon();

var MedCornerEmptyIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/med_corner_empty.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var medCornerEmpty = new MedCornerEmptyIcon();

var MedCornerFilledIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/med_corner_filled.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var medCornerFilled = new MedCornerFilledIcon();

var MfReaderEmptyIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/mf_reader_empty.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var mfReaderEmpty = new MfReaderEmptyIcon();

var MfReaderFilledIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/mf_reader_filled.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var mfReaderFilled = new MfReaderFilledIcon();

var RectTableIcon = L.Icon.extend({
	options: {
		className: 'furnitureLargeIcon',
		iconUrl: './images/icons/rect_table.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var rectTable = new RectTableIcon();

var RoomIcon = L.Icon.extend({
	options: {
		className: 'furnitureLargeIcon',
		iconUrl: './images/icons/room.png',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var roomIcon = new RoomIcon();

var SeatEmptyIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/seat_empty.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var seatEmpty = new SeatEmptyIcon();

var SeatFilledIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/seat_filled.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var seatFilled = new SeatFilledIcon();

var SeatOneSoftIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/seat_one_soft.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var seatOneSoft = new SeatOneSoftIcon();

var SeatOneIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/seat_one.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var seatOne = new SeatOneIcon();

var StudyFourIcon = L.Icon.extend({
	options: {
		className: 'furnitureLargeIcon',
		iconUrl: './images/icons/study_four.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var studyFour = new StudyFourIcon();

var StudyOneIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/study_one.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var studyOne = new StudyOneIcon();

var StudyThreeIcon = L.Icon.extend({
	options: {
		className: 'furnitureLargeIcon',
		iconUrl: './images/icons/study_three.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var studyThree = new StudyThreeIcon();

var StudyTwoIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/study_two.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var studyTwo = new StudyTwoIcon();

var VidViewerEmptyIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/vid_viewer_empty.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var vidViewerEmpty = new VidViewerEmptyIcon();

var VidViewerFilledIcon = L.Icon.extend({
	options: {
		className: 'furnitureIcon',
		iconUrl: './images/icons/vid_viewer_filled.svg',
		iconSize: [38,38],
		iconAnchor: [0,0],
		popupAnchor: [0,0]
	}
});

var vidViewerFilled = new VidViewerFilledIcon();