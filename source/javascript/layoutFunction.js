//OUT OF DATE!
//returns the stringified insert furniture data:
//v_y, v_x, degreeOffset, furniture_type, default_seat_type
function getFurnitureString(x,y,degree, ftype, defseat) {
	var returnString = "INSERT INTO FURNITURE \n('Y_LOCATION','X_LOCATION', 'LAYOUT_ID', 'FURNITURE_TYPE', 'DEGREE_OFFSET', 'DEFAULT_SEAT_TYPE') \nVALUES ("+y+","+x+", 1, "+ftype+", "+degree+", "+defseat+");";
	return returnString;
}