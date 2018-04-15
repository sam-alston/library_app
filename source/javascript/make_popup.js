/*Function bound to marker for button click*/
function markerClick(e){
	//bool check to test if we are in a different popup
	var added_seats = false;
	//document.getElementById("popupTest").style.margin = "0em";
	furnMap = getFurnMap();
	while(added_seats == false)
	{
		if(document.getElementById("seat_div_child") == null)
		{
			var seat_div_child = document.createElement("div");
			seat_div_child.id = "seat_div_child";
			document.getElementById("seat_div").appendChild(seat_div_child);

			selected_furn = furnMap.get(this.options.fid);

			//If the JS object seat_places array is as big as default number of seats, it has been surveyed
			//otherwise make the new seats and push onto array.
			//the current number of seats in the object is the default size, or the size of the array.
			var cur_num_seats;
			if(selected_furn.seat_places.length >= this.options.numSeats){
				cur_num_seats = selected_furn.seat_places.length;
			} else {
				//this is the first time the cur_furn is surveyed, so we push on the initial furniture pieces.
				cur_num_seats = this.options.numSeats;
				for (i=0; i< cur_num_seats; i++){
					//If the user added a seat that was not a default seat, set the checkbox to checked
					selected_furn.seat_places.push(new Seat(selected_furn.seat_places.seat_num));
				}
				
			}
			
			for (seat_num = 0; seat_num < cur_num_seats; seat_num++)
			{
				plus(selected_furn, seat_num+1);
			}
			added_seats = true;
		}
	
		else
		{
			//if there is a div element with the seats remove it (This is a different popup)
			var seat_div_child = document.getElementById("seat_div_child");
			seat_div_child.remove();
		}
	}
}

/*TODO: To be fixed because we do not have the number of seats in the furniture object*/
function checkAll(cur_furn){
	for(var i = 1; i <= cur_furn.num_seats; i++)
	{
		var default_seat = document.getElementById("checkbox"+i);
		default_seat.checked = true;
	}
}
//Expects: the current furniture to add seat to, and the seat number to add
//Returns: nothing
//Outputs: this will create all the default seat objects for the table, will also add a new 
//		   seat if the user push the plus button
function plus( cur_furn, seat_num)
{
	//var furniture = cur_furn;
	//used to make unique id's for each of the elements
	//var length = selected_furn.seat_places.length  + 1;

	
	//create the checkbox for the occupied input
	var cb = document.createElement('input');
	cb.type = "checkbox";
	cb.id = "checkbox"+ seat_num;
	cb.className = "inuse_input";
	cb.name = "occupied"+seat_num;

	

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
	div_content(dd_div, cur_furn);

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
			//Check to see if another dropdown is open, if it is close it
			/*if (this.id != open	&& open != "")
			{
				var div_close = document.getElementById(open);
			
				//Check to make sure we didn't remove the seat object that was open
				if(div_close != null)
				{
					div_close.className = div_close.className.replace(" active", "");
					div_close = div_close.nextElementSibling.nextElementSibling;
					div_close.style.display = "none";
				}
			}*/
		
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
					//open = this.id;
			}
		});
}


//Expects: nothing
//Returns: nothing
//Outputs: When the minus button is push this function deletes the added seats, 
//		   this does not delete the default seats and will alert the user of that
function minus(cur_furn)
{
	var length = cur_furn.seat_places.length;

	//used to make sure the user doesn't delete the default seats
	if(cur_furn.seat_places.length > cur_furn.num_seats)
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

		cur_furn.seat_places.pop();
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
function div_content(dd_div, cur_furn)
{
	var length = seat_num;
	
	var tempseat = cur_furn.seat_places[length];
	for (var property in tempseat)
	{
		if(tempseat.hasOwnProperty(property))
		{
			if(property != 'occupied')
			{
				property = titleCase(property);
				var label = document.createElement('label');
				label.id = property+length;
				label.className = "action_label";
				label.appendChild(document.createTextNode(property));
	
				//creates the checkbox for the action
				var input = document.createElement('input');
				input.type = "checkbox";
				input.id = "cb"+length;
				input.className = "action_input";
				input.name = property+length;
	
				dd_div.appendChild(input);
				dd_div.appendChild(label);
		
				var br = document.createElement('br');
				br.id = "br"+property;
	 			dd_div.appendChild(br); 
			}
		}
	}
}

//Expects: Nothing
//Returns: Nothing
//Output: Used to show and hide the whiteboard dropdown when the button is clicked
//		  also, sets class name to active when clicked, so we can change the arrow effect
function drop_func()
{
	var div = document.getElementById('wb_label');
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
