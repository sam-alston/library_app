<?php
    session_start();
?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title> Library Collect Data </title>
    <meta charset="utf-8" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <link rel="stylesheet" href="styles/layout.css" type="text/css" >
    <link rel="stylesheet" href="styles/format.css" type="text/css" >
	<link rel="stylesheet" href="styles/popup.css" type="text/css"/>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.3.1/dist/leaflet.css"
   integrity="sha512-Rksm5RenBEKSKFjgI3a41vrjkw4EVPlJ3+OiI65vTjIdo9brlAacEuKOiQ5OFh7cOI1bkDwLqdLw3Zg0cRJAAQ=="
   crossorigin=""/>
    <script src="https://unpkg.com/leaflet@1.3.1/dist/leaflet.js"
   integrity="sha512-/Nsx9X4HebavoBvEBuyp3I7od5tA0UzAxs+j83KgC8PU0kgB4XiK4Lfe4y4cgBtaRJQEIFCW+oC506aPT2L1zw=="
   crossorigin=""></script>
   <script src="./floor1.js"></script>
   <script src="./floor2.js"></script>
   <script src="./floor3.js"></script>
   <script src="./javascript/icons.js"></script>
   <script src="./javascript/layoutFunction.js"></script>
   <script src="./javascript/leaflet.rotatedMarker.js"></script>
   <script type="text/javascript">
    $(function() {
        $("#nav_toggle").click(function(){
            $("nav").toggleClass("hidden");
            $("header").toggleClass("hidden");
            $("main").toggleClass("to-top");
            $("footer").toggleClass("foot_hide");
            $(".hide_nav").toggleClass("nav_open");
            $(".submit_survey").toggleClass("nav_open");

        })
    });
    </script>
</head>
<body>
    <button class="hide_nav" id="nav_toggle">&plus;</button>
    <button class="submit_survey" id="submit_survey">Submit Survey</button>
    <header class="hidden">
        <img class="logo" src="images/hsu-wm.svg">
        <h1>Library Data Collector</h1>   
    
    
    <?php
        if (array_key_exists("username", $_SESSION)){
            ?>
            <h3 class="log-state"> Logged In: <?= $_SESSION["username"]?> </h3>
            <?php
        }
    ?>
    </header>
    <?php
        if (!array_key_exists("username", $_SESSION)){
            ?>
            <p class="invalid-login"> Please first <a href="index.php">login</a> before accessing the app</p>
            <?php
        } 
        else{
             ?>
            <nav class="hidden">
                <p class="nav"><a href="home.php">Home</a></p>
                <p class="nav selected"><a href="data-collection.php">Data Collection</a></p>
                <p class="nav"><a href="query-report.php">Query Report</a></p>
                <p class="nav"><a href="editor.php">Create A Layout</a></p>
                <p class="nav"><a href="logout.php">Logout</a></p>
            </nav>

            <?php
                $dbh = new PDO('mysql:host=localhost;dbname=hsu_library;charset=utf8mb4', 'root', '');
                $stmt1 = $dbh->query("SELECT floor FROM layout where floor = /*insert floor selected here */");
                /*statment for after layout is selected*/
                $stmt2 = $dbh->query("SELECT layout_image FROM layout where layout_id = /*Selected Layout*/");
            ?>
            <main class="to-top">
                <form class="layout-selector" id="lay-select">
                    <fieldset>
                        <!-- Set up a Query here to add options for each layout based on what floors are available in the databse-->
                        <select name="floor-select">
                            <option value="default">Choose a Floor</option>
                            <option value="floor1.svg">Floor 1</option>
                            <option value="floor2.svg">Floor 2</option>
                            <option value="floor3.svg">Floor 3</option>
                        </select>
                        <select name="layout-select">
                            <!-- Populate these options with those from the database-->
                            <option value="default">Choose a Layout</option>
                            <?php
                                $dbh = new PDO('mysql:host=localhost;dbname=hsu_library;charset=utf8mb4', 'root', '');
                                $i = 1;
                                //Will replace hardcoded floor with ajax statement to get floor when floor changes
                                foreach($dbh->query('SELECT * FROM layout WHERE floor = "1"') as $row){
                                    ?> <option value="<?= $row['layout_id'] ?>">Layout <?= $i ?> for Layout ID: <?= $row['layout_id'] ?> </option><?php
                                    $i++;
                                }
                            ?>
                        </select>
                        <button type="button" id="sub_layout">Load</button>
                    </fieldset>
                </form>
                <div id="mapid"></div>
                    <?php
                }
            ?>
                <footer class="footd foot_hide">
                    <p>Designed by HSU Library Web App team. &copy; Humboldt State University</p>
                </footer>
            </main>
<div id="popupTest">
    
    <div id="seat_div"></div>
	
	<div id="wb_div">
	<!-- Cannot have the same class name as seat dropdown button because we add a
		 event listener to the seat dropdown and search for it by class name-->
		<button onclick="wb_drop()" id="wb_button" class="wb">
			<label>Whiteboard</label></button><input type="checkbox" name="wb" class="inuse_input"/>
		
		<div id="wb_div">
			<div id="wb_label" class="div">
			
				<input type="radio" name="wb" value="partion" class="action_input"/> 
				<label class="action_label">
					Partion </label> <br />
				 
				<input type="radio" name="wb" value="writing" class="action_input"/>
				<label class="action_label">
					Writing </label> <br />
				
				<input type="radio" name="wb" value="other" class="action_input"/>
				<label class="action_label">
					Other </label> <br />
			</div>
		</div>
	</div>
	<button onclick="minus()" id="minus">-</button>
	<button onclick="plus()" id="plus">+</button> 
</div>
    
    <script>
        //generates a map location
        var submit = document.getElementById("sub_layout");
        var floor_image = "local";
        var s_layout = "local";
        var mymap = L.map('mapid', {crs: L.CRS.Simple, minZoom: 2, maxZoom: 5});
        var bounds = [[0,0], [360,550]];
        mymap.fitBounds(bounds);
        var image;
        var furnMap = new Map();
        var cur_furn;
		//used to keep track of each seat number
		var seat_num;
		

        //define our object here
            function Seat(seatnum, stype){
                this.seatPos = seatnum;
                this.type = stype;
                this.activity;
                this.occupied = null;
            }
			//added offset for marker display
            function Furniture(fid, nseats, x, y, offset, ftype, stype){
                this.furn_id = fid;
                this.num_seats = nseats;
                this.x_corr = x;
                this.y_corr = y;
				this.offset = offset;
                this.furn_type = ftype;
                this.seat_type = stype;
                this.seat_places = [];
                this.whiteboard = null;
            }

        $(function(){
            $('#lay-select').on("change", function(){
                var form_info = document.getElementById("lay-select");
                s_layout = form_info.elements["layout-select"].value;
                $.ajax({
                    url: 'data-collection.php',
                    type: 'post',
                    data:{
                        'layout-select': s_layout
                    },
                    success: function(data){
                        console.log("success, ajax ran");
                        console.log(s_layout);
                    }
                });
            });
        });

        submit.onclick = function(){
            //Test using layout in localhost with .PDO connection ect.
            if( mymap.hasLayer(image)){
                mymap.removeLayer(image);
            }
            var form_info = document.getElementById("lay-select");
            floor_image = form_info.elements.namedItem("floor-select").value;
            s_layout = form_info.elements["layout-select"].value;
			floorIMGstr = String(floor_image);
            image = L.imageOverlay('./images/' + floorIMGstr, bounds).addTo(mymap);

            
            /* MUST DEFINE A PIECE OF FURNITURE BEFORE CONSTRUCTING A SEAT */
            //Lets make our map
             
			console.log('ready to make furniture objects');
            //number of furniture to add to our map generated form our .pdo
            //pdo file must be read and processed here
            <?php
                $getfurn = $dbh->prepare('SELECT * FROM furniture WHERE layout_id = 1');

                /*$test_var = $_POST["layout-select"];

                $getfurn->bindParam(':set_layout', $test_var, PDO::PARAM_INT);*/

                $getfurn->execute();
                ?>
                console.log('Prepared Select stament and executed statement');
                <?php

                foreach ($getfurn as $row) {
                    //seperate query to get num seats based on furniture
                    ?>
                    console.log('Entered foreach statment and queried the number of seats associated with furn idea');
                    <?php

                    $numSeatsQuery = $dbh->prepare('SELECT number_of_seats
                                                    FROM furniture_type
                                                    WHERE furniture_type_id = :infurnid');

                    $numSeatsQuery->bindParam(':infurnid', $row['furniture_type'], PDO::PARAM_INT);
                    $numSeatsQuery->execute();

                    $numSeatResult = $numSeatsQuery->fetch(PDO::FETCH_ASSOC);

                    ?>
                    var keyString = "<?php echo $row['furniture_id'] ?>";
                    var newFurniture = new Furniture( <?php echo $row['furniture_id'] ?>, 
                                                      <?php echo $numSeatResult['number_of_seats'] ?>,
                                                      <?php echo $row['x_location'] ?>,
                                                      <?php echo $row['y_location'] ?>,
													  <?php echo $row['degree_offset'] ?>,
                                                      <?php echo $row['furniture_type']?>,
                                                      <?php echo $row['default_seat_type']?>
                                                     );
                    for(i = 0; i < newFurniture.num_seats; i++){
                        newFurniture.seat_places[i] = new Seat(i, newFurniture.seat_type);
                    }

                    furnMap.set(keyString, newFurniture);
                    console.log('instantiated new Furniture Object');
                    var length = furnMap.size;
                    console.log('Length of furn map is: ' + length);

                    <?php
                }
            ?>

            //place a marker for each furniture item
            var iterateMap = furnMap.values();
            for(var i of furnMap){
                console.log(i);
                cur_furn = iterateMap.next().value;
				var num_seats = cur_furn.num_seats;
                var x =  cur_furn.x_corr;
                var y = cur_furn.y_corr;
				var offset = cur_furn.offset;
                var fid = cur_furn.furn_id;
				var ftype = cur_furn.furn_type;
				var selectedIcon;
				switch(ftype){
					case 21: selectedIcon=computerStation;break;
					case 16:
					case 17:
					case 18:
					case 19: selectedIcon=collabStation; break;
					case 7:
					case 8:
					case 9:
					case 10: selectedIcon=circTable; break;
					case 13: selectedIcon=couchThree ; break;
					case 11: selectedIcon=couchCurved ; break;
					case 15: selectedIcon=couchSix ; break;
					case 14: selectedIcon=couchFour; break;
					case 12: selectedIcon=couchTwo ; break;
					case 5:
					case 6: selectedIcon=counterCurved; break;
					case 1:
					case 2:
					case 3:
					case 4: selectedIcon=rectTable ; break;
					case 33: selectedIcon=rectTable ; break;
					case 20: selectedIcon=roomIcon; break;
					case 23: selectedIcon= seatOneSoft; break;
					case 22: selectedIcon= seatOne; break;
					case 30: selectedIcon= studyFour; break;
					case 27: selectedIcon= studyOne; break;
					case 29: selectedIcon= studyThree; break;
					case 28: selectedIcon= studyTwo; break;
					default: selectedIcon= computerStation; break;
				}
                var cur_mark = L.latLng([y, x]);
                
               
				//This creates the popups content
				var popup = document.getElementById("popupTest");
				
				
				//This is the dimensions for the popup
				var popupDim = 
				{
					'maxWidth': '5000',
					'maxHeight': '5000'
				}
				
                L.marker(cur_mark, {icon: selectedIcon}).addTo(mymap).setRotationAngle(offset).bindPopup(popup, popupDim).on('click', markerClick); 
                
                
                function markerClick(e)
                {
                	
                	var added_seats = false;
                	
                	while(added_seats == false)
                	{
                		if(document.getElementById("seat_div_child") == null)
                		{
                			var seat_div_child = document.createElement("div");
                			seat_div_child.id = "seat_div_child";
                			document.getElementById("seat_div").appendChild(seat_div_child);
                		
                			for (seat_num = 0; seat_num < cur_furn.num_seats; seat_num++)
							{
								isDefualtSeat = true;
								plus(seat_num);
							}
							added_seats = true;
						}
					
						else
						{
							var seat_div_child = document.getElementById("seat_div_child");
							seat_div_child.remove();
						}
					}
                }
                
                document.getElementById("popupTest").style.display = "block";
                
    			
                //console.log("Furn at: " + x + " : " + y);
                //console.log(cur_furn);
            }
  
            //add areas based on info from .pdo file from string literals
            //this is an example

			switch(floorIMGstr){
				case "floor1.svg": floorOneAreas(mymap); break;
				case "floor2.svg": floorTwoAreas(mymap); break;
				case "floor3.svg": floorThreeAreas(mymap); break;
			}
			
			
			/*function onMapClick(e) {
                alert("You clicked the map at " + e.latlng);
            }*/

            //mymap.on('click', onMapClick);
            //end of submit function
        };
        
                  
			//Used to keep track of the seat drop down that is open
var open = "";
//Used to keep track of if the seat being added is a default seat or a seat that was added on
//Needed so we can automatically check the checkbox when adding seats
var isDefualtSeat = false;
var actions = ['occupied', 'study', 'social', 'tech'];

//Expects: nothing
//Returns: nothing
//Outputs: this will create all the default seat objects for the table, will also add a new 
//		   seat if the user push the plus button
function plus()
{
	var furniture = cur_furn;
//used to make unique id's for each of the elements
	var length = seat_num + 1;
	
//create the checkbox for the occupied input
	var cb = document.createElement('input');
	cb.type = "checkbox";
	cb.id = "checkbox"+ length;
	cb.className = "inuse_input";
	cb.name = "occupied"+length;
	
//If the user added a seat that was not a default seat, set the checkbox to checked
	if (!isDefualtSeat)
	{
		cur_furn.seat_places.push(new Seat(cur_furn.seat_places.length, cur_furn.seat_type));
		seat_num++;
		cb.checked = true;
		
	}
	
//creates a button for a drop down menu for each seat
	var dd_button = document.createElement('button');
	dd_button.name = "dropdown";
	dd_button.id = "dd_button"+length;
	dd_button.className = "dropbutton";

//append the text for the seat to the button so we can change the arrow
//also makes it easier for the user to press
	dd_button.appendChild(document.createTextNode(' Seat ' + (length)));
	
//creates a div the will be in the drop down menu with more options for each seat
	var dd_div = document.createElement('div');
	dd_div.name = "div";
	dd_div.id = "dd_div" + length;
	dd_div.className = "div";
	div_content(dd_div, furniture ,length);

//adds a new line for each seat
	var br = document.createElement('br');
	br.id = "br"+length;
	
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
    			if (this.id != open	&& open != "")
    			{
    				var div_close = document.getElementById(open);
    				
    			//Check to make sure we didn't remove the seat object that was open
    				if(div_close != null)
    				{
    					div_close.className = div_close.className.replace(" active", "");
    					div_close = div_close.nextElementSibling.nextElementSibling;
    					div_close.style.display = "none";
    				}
    			}
    			
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
           			open = this.id;
        		}
    		});
    		
//Reset the the bool check for a default seat
    isDefualtSeat = false;
}


//Expects: nothing
//Returns: nothing
//Outputs: When the minus button is push this function deletes the added seats, 
//		   this does not delete the default seats and will alert the user of that
function minus(){
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
function div_content(dd_div)
{
	var length = seat_num + 1;
	var tempseat = cur_furn.seat_places[seat_num]
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
function wb_drop()
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

		
		//On zoomend, resize the marker icons
		mymap.on('zoomend', function() {
			var markerSize;
			//resize the markers depending on zoomlevel so they appear to scale
			//zoom is limited to 0-4
			switch(mymap.getZoom()){
				case 0: markerSize= 5; break;
				case 1: markerSize= 10; break;
				case 2: markerSize= 20; break;
				case 3: markerSize= 40; break;
				case 4: markerSize= 80; break;
			}
			//alert(mymap.getZoom)());
			var newzoom = '' + (markerSize) +'px';
			var newLargeZoom = '' + (markerSize*2) +'px';
			//marker = L.marker(e.latlng, {icon: couchFour }).addTo(furnitureLayer).bindPopup("I am a Computer Station.");
			$('#mapid .furnitureIcon').css({'width':newzoom,'height':newzoom});
			$('#mapid .furnitureLargeIcon').css({'width':newLargeZoom,'height':newLargeZoom});			
		});

    
</script>
    
</body>
</html>