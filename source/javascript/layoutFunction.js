//returns the stringified furniture data:
//v_y, v_x, degreeOffset, furniture_type, default_seat_type
function getFurnitureString(x,y,degree, ftype, defseat,area_id) {
	var returnString = "INSERT INTO FURNITURE (Y_LOCATION,X_LOCATION, LAYOUT_ID, FURNITURE_TYPE, DEGREE_OFFSET, DEFAULT_SEAT_TYPE, IN_AREA) \nVALUES ("+y+","+x+", 1, "+ftype+", "+degree+", 32, "+area_id+");";
	return returnString;
}