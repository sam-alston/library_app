//This file extends Marker to contain furniture information
//and extend Icon class to create new icons for each piece of furniture

//contains function to return selected icon type based on furniture type

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
        iconAnchor:   [0,0],
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
		className: 'furnitureLargeIcon',
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

//return the icon type based on furniture typefunction 
//takes an int
//returns Icon object

function getIconObj(furniture_type) {
	
	var selectedIcon;
	switch(furniture_type){
		case 1:
		case 2:
		case 3:
		case 4: selectedIcon=rectTable ; break;
		case 5:
		case 6: selectedIcon=counterCurved; break;
		case 7:
		case 8:
		case 9:
		case 10: selectedIcon=circTable; break;
		case 11: selectedIcon=couchCurved ; break;
		case 12: selectedIcon=couchTwo ; break;
		case 13: selectedIcon=couchThree ; break;
		case 14: selectedIcon=couchFour; break;
		case 15: selectedIcon=couchSix ; break;
		case 16:
		case 17:
		case 18:
		case 19: selectedIcon=collabStation; break;
		case 20: selectedIcon=roomIcon; break;
		case 21: selectedIcon=computerStation;break;
		case 22: selectedIcon= seatOne; break;
		case 23: selectedIcon= seatOneSoft; break;
		case 24: selectedIcon= fitDeskEmpty; break;
		case 25: selectedIcon= medCornerEmpty; break;
		case 26: selectedIcon= mfReaderEmpty; break;
		case 27: selectedIcon= studyOne; break;
		case 28: selectedIcon= studyTwo; break;
		case 29: selectedIcon= studyThree; break;
		case 30: selectedIcon= studyFour; break;
		case 31: selectedIcon= vidViewerEmpty; break;
		case 33: selectedIcon=rectTable ; break;
		default: selectedIcon= computerStation; break;
	}
	return selectedIcon;
}