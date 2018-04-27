//This function will take a furniture object and
//return the string statement to update its location data
function updateFurn(furn){
	return "UPDATE furniture SET x_location = "+furn.x+", y_location = "+furn.y+", degree_offset = "+furn.degreeOffset+", in_area = "+furn.in_area+" WHERE furniture_id = "+furn.furn_id+";";
}