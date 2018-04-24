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
    <link rel="stylesheet" href="styles/popup.css" type="text/css" >
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.3.1/dist/leaflet.css"
   integrity="sha512-Rksm5RenBEKSKFjgI3a41vrjkw4EVPlJ3+OiI65vTjIdo9brlAacEuKOiQ5OFh7cOI1bkDwLqdLw3Zg0cRJAAQ=="
   crossorigin=""/>
    <script src="https://unpkg.com/leaflet@1.3.1/dist/leaflet.js"
   integrity="sha512-/Nsx9X4HebavoBvEBuyp3I7od5tA0UzAxs+j83KgC8PU0kgB4XiK4Lfe4y4cgBtaRJQEIFCW+oC506aPT2L1zw=="
   crossorigin=""></script>
   <script src="./scripts/floor1.js"></script>
   <script src="./scripts/floor2.js"></script>
   <script src="./scripts/floor3.js"></script>
   <script src="./javascript/get_layouts.js"></script>
   <script src="./javascript/icons.js"></script>
   <script src="./javascript/layoutFunction.js"></script>
   <script src="./javascript/leaflet.rotatedMarker.js"></script>
   <script src="./javascript/submit_survey.js"></script>
   <script src="./javascript/make_popup.js"></script>
   <script src="./javascript/pop-activities.js"></script>
   <script type="text/javascript">
    /*Container for JS furniture objects*/
    /*This functions to manipulate the view of the navigation, header, and footer with the click of a button*/
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
    <?php
        require_once('form_functions.php');
    ?>
</head>
<body>
    <button class="hide_nav" id="nav_toggle">&plus;</button>
    <button class="submit_survey hidden" id="submit_survey" onclick="if(confirm('Are you sure you want to submit this survey?')) submitSurveyHelper();">Submit Survey</button>
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
    /*If the user is not logged in, they will trigger this if statement*/
    if (!array_key_exists("username", $_SESSION)){
        ?>
        <p class="invalid-login"> Please first <a href="index.php">login</a> before accessing the app</p>
        <?php
    }
    /*If user is logged in the else statement fires, building out the Floor Select, Layout Select, and the Leaflet.js map div*/

    /******All contents in this if else statement inside this else to be replaced with AJAX calls, leading to dynamic creation of layout select******/
    else{
        nav_form();
        $dbh = new PDO('mysql:host=localhost;dbname=hsu_library;charset=utf8mb4', 'root', '');

        /*Checks to see if you have selected a form, in order to build the proper layout select, if you have selected a floor, this if statement fires*/
        /*********To Be Replaced with form function*********/
        $_SESSION['cur_floor'] = $_POST['floor-select'];
        ?>
        <main class="to-top">
            <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" class="layout-selector" id="lay-select">
                <fieldset>
                    <select name="floor-select" id="floor-select">
                        <option value="0" selected="selected">Choose a Floor</option>
                        <option value="1" >Floor 1</option>
                        <option value="2">Floor 2</option>
                        <option value="3">Floor 3</option>
                    </select>
                    <select name="layout-select" id="current_layouts">
                        <option value="default">Choose a Layout</option>
                    </select>
                    <input type="submit" id="sub_layout" value="Load Layout"/>
                </fieldset>
            </form>
       
            <div id="mapid"></div>
            <div id="popupTest">
                <div id="seat_div"></div>
                <div id="wb_div">
                <!-- Cannot have the same class name as seat dropdown button because we add a
                    event listener to the seat dropdown and search for it by class name-->
                <button onclick="drop_func()" id="wb_button" class="wb">
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
                <button onClick="saveHelper()" id="save" style="display:none">Save and Exit</button>
                <button onClick="lockHelper()" id="lock">Unlock</button>
		<button onClick="rotateHelper()" id="rotate">Rotate</button>
                <button onClick="checkAllHelper()" id="checkall" style="display:none">Check All</button>
                <label id="seat_operator"></label>
                <button onclick="minusHelper()" id="minus" style="display:none">-</button>
                <button onclick="plusHelper()" id="plus" style="display:none">+</button>
            </div>
            <div class="loading">
                <img src="images/loadwheel.svg" id="load-image">
            </div>
            <footer class="footd foot_hide">
                <p>Designed by HSU Library Web App team. &copy; Humboldt State University</p>
            </footer>
        </main>
        <?php 
        }
        ?>
    </body>
    <script>
        //generates a map location
        var submit = document.getElementById("sub_layout");
        var floor_image = "local";
        var s_layout = "local";
        var layout ="default";

        var mymap = L.map('mapid', {crs: L.CRS.Simple});
        var furnitureLayer = L.layerGroup().addTo(mymap);
        var bounds = [[0,0], [360,550]];
        mymap.fitBounds(bounds);
        var image;
        var selected_furn;
		var selected_marker;
        var seat_num;
		//to store the seat_places array to be saved
		var temp_seat_places = [];
        var furnMap = new Map();
		var activityMap = new Map();

        var popup = document.getElementById("popupTest"); 
        
        var popupDim = 
        {
            'maxWidth': '5000',
            'maxHeight': '5000'
        };//This is the dimensions for the popup

        //This function gets all the layouts for the florr and populates the dropdown
        $(function(){
            $('#floor-select').on("change", function(){
                var form_info = document.getElementById("lay-select");
                floor_ID = form_info.elements["floor-select"].value;

                //Get rid previous select options before repopulating 
                var select = document.getElementById('current_layouts');
                var length = select.options.length;
                if(length > 1){
                    for(i = 0; i < length; i++){
                        select.remove(1);
                    }
                }
                $.ajax({
                    url: 'phpcalls/floor-select.php',
                    type: 'get',
                    data:{ 'floor_ID': floor_ID },
                    success: function(data){
                        /*need to replace with ajax call getting actual layout id's*/

                        console.log("got number of layouts");
                        var json_object = JSON.parse(data);
                        var lay_select = document.getElementById('current_layouts');

                        for(var i = 0; i < json_object.length; i++){
                            var obj = json_object[i];
                            lay_id = obj['layout_id'];
                            var option = document.createElement('option');
                            option.value = lay_id;
                            option.innerHTML = "Layout " + lay_id +" for Floor";
                            lay_select.appendChild(option);
                        }
                    }
                });
            });
        });

        $(function(){
            $('#current_layouts').on("change", function(){
                var form_info = document.getElementById("lay-select");
                layout = form_info.elements["layout-select"].value;
            });
        });

        function getFurnMap(){
            return furnMap;
        }

        function getActivityMap(){
            return activityMap;
        }

        function checkAllHelper(){
        	checkAll(selected_furn);
        }
        
        function saveHelper(){
			var occupants = document.getElementById("occupantInput");
			if(occupants){
				selected_furn.totalOccupants = occupants.value;
			}
			selected_marker.setOpacity(1);
			selected_furn.seat_places = temp_seat_places;
        	mymap.closePopup();
        }
        
        function lockHelper(){
        	var lockButton = document.getElementById("lock");
        	
        	if(lockButton.innerText === "Unlock")
        	{
				selected_marker.dragging.enable();
        		lockButton.innerText = "Lock";
        	}        	
        	else
        	{
				selected_marker.dragging.disable();
        		lockButton.innerText = "Unlock";
        	}
        }
	    
	function rotateHelper()
        {
        	if(document.getElementById("rotateSlider") == null)
        	{
        		var rotateSlider = document.createElement("input");
        		rotateSlider.type = "range";
        		rotateSlider.min = "-180";
        		rotateSlider.max = "180";
        		rotateSlider.value = "0";
        		rotateSlider.step = "10";
        		rotateSlider.id = "rotateSlider";
        		
        		var sliderValue = document.createElement("p");
        		sliderValue.id = "sliderValue";
        		sliderValue.innerText = "Value: 0";
        		
        		document.getElementById("seat_div_child").appendChild(sliderValue);
        		document.getElementById("seat_div_child").appendChild(rotateSlider);
        	
        			
        		rotateSlider.oninput = function()
        		{
        			selected_marker.setRotationOrigin("center");
        			selected_marker.options.degreeOffset = rotateSlider.value;
        			selected_marker.setRotationAngle(rotateSlider.value);
        			sliderValue.innerText = "Value: " + rotateSlider.value;
        		}
        	}
        	
        	else
        	{
        		document.getElementById("rotateSlider").remove();
        		document.getElementById("sliderValue").remove();
        	}
        
        }
        
        
        function minusHelper(){
            minus(selected_furn);
        }

        function plusHelper(){
			//selected_furn.seat_places.push(new Seat(selected_furn.seat_places.length));
            temp_seat_places.push(new Seat(temp_seat_places.length));
			//plus(selected_furn, selected_furn.seat_places.length);
			//pass true for occupied because we are adding another seat to the default
			plus(temp_seat_places, temp_seat_places.length, true);
			checkAll(selected_furn);
        }

        //define our object here
        function Seat(seatPos){
            this.seatPos = seatPos;
            //this.type = type;
            this.activity = [];
            this.occupied = false;
        }

        function Furniture(fid, num_seats){
            this.furn_id = fid;
            this.num_seats = num_seats;
            this.seat_places = [];
			this.seat_type = 32;
            this.whiteboard = 0;
			this.totalOccupants = 0;
        }

        //checks the constant state of the Layout and Builds out the view
        $(document).ready(function(){
            /*To be placed in seperate javascript function, when php is removed*/
            //Test using layout in localhost with .PDO connection ect.
            if( mymap.hasLayer(image)){
                mymap.removeLayer(image);
            }
            var form_info = document.getElementById("lay-select");
            floor_image = "<?php echo $_SESSION['cur_floor'] ?>";
            s_layout = form_info.elements["layout-select"].value;
            floorIMGstr = String(floor_image);
            var FLOOR1 = "1";
            var FLOOR2 = "2";
            var FLOOR3 = "3";
            var floor_name;

            switch(floorIMGstr){
                case FLOOR1:
                    image = L.imageOverlay('images/floor1.svg', bounds).addTo(mymap);
                    break;
                case FLOOR2:
                    image = L.imageOverlay('images/floor2.svg', bounds).addTo(mymap);
                    break;
                case FLOOR3: 
                    image = L.imageOverlay('images/floor3.svg', bounds).addTo(mymap);
                    break;
            }
            
           
            $(".submit_survey").removeClass("hidden");
            /* MUST DEFINE A PIECE OF FURNITURE BEFORE CONSTRUCTING A SEAT */
            //Lets make our map
            console.log('ready to make furniture objects');
            //number of furniture to add to our map generated form our .pdo
            //pdo file must be read and processed here

            <?php
            /*TODO: CLEAR POST SO THAT ON RELOAD, LAYOUT ISN'T BUILT*/
            if(array_key_exists("layout-select", $_POST)){
                ?>
                layout = "<?php echo $_POST['layout-select']?>";
                <?php

                $_SESSION['cur_layout'] = $_POST['layout-select'];

				

                $getfurn = $dbh->prepare('SELECT * FROM furniture WHERE layout_id = :set_layout');

                $layout = $_POST["layout-select"];

                $getfurn->bindParam(':set_layout', $layout, PDO::PARAM_INT);

                $getfurn->execute();

                ?>

                console.log('Prepared Select stament and executed statement');

                <?php
                foreach ($getfurn as $row) {
                    //seperate query to get num seats based on furniture
                    /*To be replaced with ajax call*/

                    $numSeatsQuery = $dbh->prepare('SELECT number_of_seats
                                                    FROM furniture_type
                                                    WHERE furniture_type_id = :infurnid');

                    $numSeatsQuery->bindParam(':infurnid', $row['furniture_type'], PDO::PARAM_INT);
                    $numSeatsQuery->execute();

                    $numSeatResult = $numSeatsQuery->fetch(PDO::FETCH_ASSOC);

                    ?>
                    /*Creating furniture container*/
                    var keyString = "<?php echo $row['furniture_id'] ?>";
                    var newFurniture = new Furniture( <?php echo $row['furniture_id'] ?>,
                                                      <?php echo $numSeatResult['number_of_seats'] ?>);

                    x = <?php echo $row['x_location'] ?>;
                    y = <?php echo $row['y_location'] ?>;
                    degreeOffset = <?php echo $row['degree_offset'] ?>;
                    furniture_type = <?php echo $row['furniture_type'] ?>;
                    default_seat_type = <?php echo $row['default_seat_type'] ?>;
                    num_seats = <?php echo $numSeatResult['number_of_seats'] ?>;
                    var latlng = [y,x];
                    var selectedIcon;

                    switch(furniture_type){
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

                    /*Add erics code to get rid of bind and open popup*/
                    //place a marker for each furniture item
                    marker = L.marker(latlng, {
                        icon: selectedIcon,
                        rotationAngle: degreeOffset,
                        draggable: false,
                        ftype: furniture_type,
                        numSeats: num_seats,
                        fid: keyString
                    }).addTo(furnitureLayer).bindPopup(popup, popupDim);

                    marker.on('click', markerClick);
					marker.setOpacity(.3);
					
					//update marker coords in marker map on dragend, set to modified
					marker.on("dragend", function(e){
						selected_furn.modified = true;
						selected_furn.in_area = 1;
						selected_furn.latlng = e.target.getLatLng();
					});

                    /*TODO: Seat's made on survey, not furniture creation*/
                    /*for(i = 0; i < newFurniture.num_seats; i++){
                        newFurniture.seat_places[i] = new Seat(i, newFurniture.seat_type);
                    }*/

                    document.getElementById("plus").style.display = "block";
                    document.getElementById("minus").style.display = "block";
                    document.getElementById("checkall").style.display = "block";
                    document.getElementById("save").style.display = "block";
                    document.getElementById("wb_div").style.display = "block";

                    furnMap.set(keyString, newFurniture);
                    <?php
                }
				

				
                ?>
                //add areas based on info from .pdo file from string literals
                //this is an example
                switch(floorIMGstr){
                    case "1": floorOneAreas(mymap); break;
                    case "2": floorTwoAreas(mymap); break;
                    case "3": floorThreeAreas(mymap); break;
                }
                <?php
            }
            ?>
        });

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
            $('#mapid .furnitureIcon').css({'width':newzoom,'height':newzoom});
            $('#mapid .furnitureLargeIcon').css({'width':newLargeZoom,'height':newLargeZoom});          
        });

        //On click of submission, Create's a Survey Record and Inserts each seat object into the database with that ID
        function submitSurveyHelper(){
            var username = "<?php echo $_SESSION['username']?>";
            submitSurvey(username, layout, furnMap);
        };

    </script>
</html>
