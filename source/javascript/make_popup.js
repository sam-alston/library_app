/*Function bound to marker for button click*/
function markerClick(e){
	//bool check to test if we are in a different popup
	var added_seats = false;
	//document.getElementById("popupTest").style.margin = "0em";
	furnMap = getFurnMap();
	activityMap = getActivityMap();
	wb_activityMap = getWhiteboardActivityMap();
	document.getElementById("lock").style.display = "inline";
	document.getElementById("rotate").style.display = "block";
	document.getElementById("lock").innerText = "Unlock";
	document.getElementById("rotate").style.display = "block";
	document.getElementById("plus").style.display = "block";
  document.getElementById("minus").style.display = "block";
  document.getElementById("checkall").style.display = "block";
	document.getElementById("save").style.display = "block";
	
	selected_furn = furnMap.get(this.options.fid);
	selected_marker = this;
	selected_marker.dragging.disable();
	
	temp_seat_places = [];
	whiteboard_activity = "0";

	while(added_seats == false)
	{
		if(document.getElementById("seat_div_child") == null)
		{
			var seat_div_child = document.createElement("div");
			seat_div_child.id = "seat_div_child";
			document.getElementById("seat_div").appendChild(seat_div_child);

			//If the JS object seat_places array is as big as default number of seats, it has been surveyed
			//otherwise make the new seats and push onto array.
			//the current number of seats in the object is the default size, or the size of the array.
			var cur_num_seats;
			var surveyExists = true;
			//check if it has been surveyed it will have seats in the array
			if(selected_furn.seat_places.length >= this.options.numSeats){
				cur_num_seats = selected_furn.seat_places.length;
			} else {
				surveyExists = false;
				//this is the first time the cur_furn is surveyed, so we push on the initial furniture pieces.
				cur_num_seats = this.options.numSeats;
			}
			
			
			for (seat_num = 0; seat_num < cur_num_seats; seat_num++)
			{
				//newSeat = new Seat(seat_num);
				if(surveyExists)
				{
					var copy_seat = Object.assign({}, selected_furn.seat_places[seat_num]);
					if(Array.isArray(copy_seat.activity)){
						copy_seat.activity = copy_seat.activity.slice();
					}
					temp_seat_places.push(copy_seat);
				}
				else
				{
					temp_seat_places.push(new Seat(seat_num));
				}
				plus(temp_seat_places[seat_num], seat_num+1);
			}
			
			//find +/- buttons to st onclick
			plusbutton = document.getElementById("plus");
			minusbutton = document.getElementById("minus");
			
			if(this.options.numSeats === 0){
				//add room input
				
				addRoomInput(selected_furn.totalOccupants);
				minusbutton.disabled = true;
				plusbutton.disabled = true;
				
			} else {
				//not a room, reattach +/- buttons to plusHelper/minusHelper
				minusbutton.disabled = false;
				plusbutton.disabled = false;
			}
			added_seats = true;
		}
	
		else
		{
			//if there is a div element with the seats remove it (This is a different popup)
			var seat_div_child = document.getElementById("seat_div_child");
			seat_div_child.remove();
			
			var wb_div_child = document.getElementById("wb_div_child");
			wb_div_child.remove();
		}
	}
	
	var wbActivityValues = wb_activityMap.values();
	var wb_div_child = document.createElement("div");
	wb_div_child.id = "wb_div_child";
	document.getElementById("wb_div").appendChild(wb_div_child);
	
	//creates a button for a drop down menu for whiteboard
	var wb_button = document.createElement('button');
	//wb_button.name = "dropdown";
	wb_button.id = "wb_button";
	wb_button.className = "wb";
	wb_button.appendChild(document.createTextNode('Whiteboard'));

	//creates a div the will be in the drop down menu with more options for whiteboard
	var wb_dd_div = document.createElement('div');
	wb_dd_div.name = "div";
	wb_dd_div.id = "wb_dropContent";
	wb_dd_div.style.display = "none";
	wb_dd_div.className = "div";
	
	for(var property of wb_activityMap)
	{
		var cur_prop = wbActivityValues.next().value;

		cur_prop = titleCase(cur_prop);
		var label = document.createElement('label');
		label.className = "action_label";
		label.appendChild(document.createTextNode(cur_prop));

		var input = document.createElement('input');
		input.type = "radio";
		input.className = "action_input";
		input.name = "wb_activity";
		input.value = cur_prop;
		input.onchange = function()
		{
			whiteboard_activity = this.value;
		}
		
		if(selected_furn.whiteboard == cur_prop)
		{
			input.checked = true;
		}
		
		wb_dd_div.appendChild(input);
		wb_dd_div.appendChild(label);
		

		var br = document.createElement('br');
		wb_dd_div.appendChild(br);
	}
	wb_div_child.appendChild(wb_button);
	wb_div_child.appendChild(wb_dd_div);
	wb_button.onclick = function()
	{
		var div = document.getElementById("wb_dropContent");
		if (div.style.display === "block") 
		{
			div.style.display = "none";
			wb_button.className = wb_button.className.replace(" active", "");
		} 
		
		else 
		{
    		div.style.display = "block";
			wb_button.className += " active";
		}
	};
	 
}


/*sets all seats of the selected furniture to occupied*/
function checkAll(cur_furn){
	
	//for(var i = 1; i <= cur_furn.seat_places.length; i++)
	for( var i = 1; i <= temp_seat_places.length; i++)
	{
		//elements are named after seat place, 1 indexed, seat_places array is 0 indexed
		var default_seat = document.getElementById("checkbox"+i);
		//cur_furn.seat_places[i-1].occupied = true;
		temp_seat_places[i-1].occupied = true;
		default_seat.checked = true;
	}
}

function addRoomInput(currentOccupants){
	var occupantsInput = document.createElement('input');
	occupantsInput.type = "number";
	occupantsInput.id = "occupantInput";
	occupantsInput.min = 0;
	document.getElementById("seat_div_child").appendChild(occupantsInput);
	occ = document.getElementById("occupantInput");
	occ.value = currentOccupants;
	
	if(temp_seat_places.length === 0){
		var roomSeat = new Seat(0);
		temp_seat_places.push(roomSeat);
		plus(roomSeat, 1);
	} else {
		var roomSeat = temp_seat_places[0];
	}
	seat = document.getElementById("dd_button"+1);
	seat.textContent="Room activity";
	
	
}
//Expects: the current furniture to add seat to, and the seat number to add
//Returns: nothing
//Outputs: this will create all the default seat objects for the table, will also add a new 
//		   seat if the user push the plus button
function plus( cur_seat, seat_num)
{
	//get the current seat from seat_places
	//var cur_seat = cur_furn.seat_places[seat_num-1];
	//var cur_seat = temp_seat_places[seat_num-1];
	//create the checkbox for the occupied input
	var cb = document.createElement('input');
	cb.type = "checkbox";
	cb.id = "checkbox"+ seat_num;
	cb.className = "inuse_input";
	cb.name = "occupied"+seat_num;
	
	if(cur_seat.occupied == true)
	{
		cb.checked = true;
	}
	//cb.checked = occupiedBool;
	//cur_seat.occupied = occupiedBool;
	//onchange listener sets occupied state
	cb.onchange = function(){
		if(cb.checked === true){
			cur_seat.occupied = true;
		} else {
			cur_seat.occupied = false;
		}
	};

	

	//creates a button for a drop down menu for each seat
	var dd_button = document.createElement('button');
	dd_button.name = "dropdown";
	dd_button.id = "dd_button"+seat_num;
	dd_button.className = "dropbutton";

	//append the text for the seat to the button so we can change the arrow
	//also makes it easier for the user to press
	dd_button.appendChild(document.createTextNode(' Seat ' + (seat_num)));

	//creates a div the will be in the drop down menu with more options for each seat
	var dd_div = document.createElement('div');
	dd_div.name = "div";
	dd_div.id = "dd_div" + seat_num;
	dd_div.className = "div";
	div_content(dd_div, cur_seat);

	//adds a new line for each seat
	var br = document.createElement('br');
	br.id = "br" + seat_num;

	//Append each element to the document
	if(document.getElementById("seat_div_child") != null)
	{
		document.getElementById("seat_div_child").appendChild(dd_button);
		document.getElementById("seat_div_child").appendChild(cb);
		document.getElementById("seat_div_child").appendChild(dd_div);
		document.getElementById("seat_div_child").appendChild(br);
	}

	//this is the variable for the drop down menu
	var dd = document.getElementsByClassName("dropbutton");

	//Adds a click listener to the drop down button to open the dropdown menu
	dd[(dd.length - 1)].addEventListener("click", 
		function() 
		{
			var div = this.nextElementSibling.nextElementSibling;
				if (div.style.display === "block") 
				{
				div.style.display = "none";
				this.className = this.className.replace(" active", "");
			} 
		
			else 
			{
					div.style.display = "block";
					this.className += " active";
			}
		});
}


//Expects: nothing
//Returns: nothing
//Outputs: When the minus button is push this function deletes the added seats, 
//		   this does not delete the default seats and will alert the user of that
function minus(cur_furn)
{
	//var length = cur_furn.seat_places.length;
	var length = temp_seat_places.length;
	
	//used to make sure the user doesn't delete the default seats
	if(temp_seat_places.length > cur_furn.num_seats)	
	{
		//removing each of the element in the the popup
		var removeDD = document.getElementById("dd_button"+length);
		removeDD.remove();

		var removeDD_div = document.getElementById("dd_div"+length);
		removeDD_div.remove();

		var removeCB = document.getElementById("checkbox"+length);
		removeCB.remove();

		var removeBR = document.getElementById("br"+length);
		removeBR.remove();

		//cur_furn.seat_places.pop();
		temp_seat_places.pop();
		seat_num--;
	}
	//If the user tries to delete a default seat prompt an error telling them they can't
	else
	{
		alert("You can't remove default seats");
	}
}


//Expects: The div wrapper for the drop down
//Returns: nothing
//Outputs: All the actions of the seat object as elements with a checkbox 
function div_content(dd_div, cur_seat)
{
	var length = seat_num;
	var actMapValues = activityMap.values();
	for(var property of activityMap){
		var cur_prop = actMapValues.next().value;

		cur_prop = titleCase(cur_prop);
		var label = document.createElement('label');
		label.id = cur_prop+length;
		label.className = "action_label";
		label.appendChild(document.createTextNode(cur_prop));

		var input = document.createElement('input');
		input.type = "checkbox";
		input.className = "action_input";
		input.name = cur_prop+length;
		input.value = cur_prop;
		input.onchange = function()
		{
			//if they are given an activity, the seat will be occupied. Make it so.
			cur_seat.occupied = true;
			//get the CB of the Seat object
			seatOccupiedCB = document.getElementById("checkbox"+(cur_seat.seatPos+1));
			seatOccupiedCB.checked = true;
			
			var activityCheck = isInArray(cur_seat.activity, this.value);	
			if (!activityCheck)
			{
				cur_seat.activity.push(this.value);
			}
		}
		
		if(cur_seat.activity.length > 0)
		{
			for(var i = 0; i < cur_seat.activity.length; i++)
			{
				if(cur_seat.activity[i] === cur_prop)
				{
					input.checked = true;
				}
			} 
		}

		dd_div.appendChild(input);
		dd_div.appendChild(label);
		

		var br = document.createElement('br');
		br.id = "br"+cur_prop;
		dd_div.appendChild(br); 
	}
}

function isInArray(cur_array, cur_value)
{
	for(var i = 0; i < cur_array.length; i++)
	{
		if(cur_array[i] === cur_value)
		{
			cur_array.splice(i, 1);
			return true;
		}
	}
	
	return false;
}


//Expects: Nothing
//Returns: Nothing
//Output: Used to show and hide the whiteboard dropdown when the button is clicked
//		  also, sets class name to active when clicked, so we can change the arrow effect
function drop_func()
{
	var div = document.getElementById("wb_dropContent");
	if (div.style.display === "block") 
	{
		div.style.display = "none";
		wb_button.className = wb_button.className.replace(" active", "");
	} 
		
	else 
	{
    	div.style.display = "block";
		wb_button.className += " active";
	}
}

//Expects: String
//Returns: That string in titlecase
//Output: Used to make all the seats and actions titlecase
function titleCase(str)
{
	str = str.charAt(0).toUpperCase() + str.substr(1).toLowerCase();
	return str;
}