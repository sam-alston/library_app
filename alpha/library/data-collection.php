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
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.3.1/dist/leaflet.css"
   integrity="sha512-Rksm5RenBEKSKFjgI3a41vrjkw4EVPlJ3+OiI65vTjIdo9brlAacEuKOiQ5OFh7cOI1bkDwLqdLw3Zg0cRJAAQ=="
   crossorigin=""/>
    <script src="https://unpkg.com/leaflet@1.3.1/dist/leaflet.js"
   integrity="sha512-/Nsx9X4HebavoBvEBuyp3I7od5tA0UzAxs+j83KgC8PU0kgB4XiK4Lfe4y4cgBtaRJQEIFCW+oC506aPT2L1zw=="
   crossorigin=""></script>
   <script src="./js/floor1.js"></script>
   <script src="./js/floor2.js"></script>
   <script src="./js/floor3.js"></script>
   <script src="./js/icons.js"></script>
   <script src="./js/layoutFunction.js"></script>
   <script src="./js/leaflet.rotatedMarker.js"></script>
   <script type="text/javascript">
    $(function() {
        $("#nav_toggle").click(function(){
            $("nav").toggleClass("hidden");
            $("header").toggleClass("hidden");
            $("main").toggleClass("to-top");
            $("footer").toggleClass("hidden");
            $(".hide_nav").toggleClass("nav_open");
        })
    });
    </script>
</head>
<body>
    <button class="hide_nav" id="nav_toggle">&plus;</button>
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
                            <option value="lay-1">Layout 1</option>
                            <option value="lay-2">Layout 2</option>
                        </select>
						<select name="furniture-select">
							<!-- temporary layout editor tool -->
							<option value="computerStation">Comp Station </option>
							<option value="collaborationStation">Collab Station </option>
							<option value="circTable">circTable</option>
							<option value="couchThree">couchThree </option>
							<option value="couchCurved">couchCurved </option>
							<option value="couchSix">couchSix </option>
							<option value="couchTwo">couchTwo </option>
							<option value="counterCurved">counterCurved </option>
							<option value="fitDeskEmpty">fitDeskEmpty </option>
							<option value="medCornerEmpty">medCornerEmpty </option>
							<option value="mfReaderEmpty">mfReaderEmpty </option>
							<option value="rectTable">rectTable </option>
							<option value="room">room </option>
							<option value="seatOneSoft">seatOneSoft </option>
							<option value="seatOne">seatOne </option>
							<option value="studyFour">studyFour </option>
							<option value="studyOne">studyOne </option>
							<option value="studyThree">studyThree </option>
							<option value="studyTwo">studyTwo </option>
							<option value="vidViewerEmpty">vidViewerEmpty </option>
						</select>
						<div> Degree offset: <input name="degree-offset" id="degree-offset" type="number" value=0></input>
						</div>
						<div> Number of seats: <input name="numseats" id="numseats" type="number" value=0></input>
						</div>
                        <button type="button" id="sub_layout">Submit</button>
						<button type="button" id="printfurn">Print Furn</button>
                    </fieldset>
                </form>
                <div id="mapid"></div>
                    <?php
                }
            ?>
                <footer class="footd hidden">
                    <p>Designed by HSU Library Web App team. &copy; Humboldt State University</p>
                </footer>
            </main>
    <script>
	
        //generates a map location
        var submit = document.getElementById("sub_layout");
		var print = document.getElementById("printfurn");
        var floor_image = "local";
        var s_layout = "local";
        var mymap = L.map('mapid', {crs: L.CRS.Simple, minZoom: 0, maxZoom: 4});
		var furnitureLayer = L.layerGroup().addTo(mymap);
		var drawnItems = new L.FeatureGroup();
        var bounds = [[0,0], [360,550]];
        var image;
        mymap.fitBounds(bounds);
		
        submit.onclick = function(){
            //Test using layout in localhost with .PDO connection ect.
            if( mymap.hasLayer(image)){
                mymap.removeLayer(image);
            }
            var form_info = document.getElementById("lay-select");
            //var test =  document.getElementById("text");
            floor_image = form_info.elements.namedItem("floor-select").value;
            s_layout = form_info.elements["layout-select"].value;
            //test.innerHTML = floor_image;
			floorIMGstr = String(floor_image);
            image = L.imageOverlay('./images/' + floorIMGstr, bounds).addTo(mymap);
            //pdo file must be read and processed here
            //define our object here
            function Seat(seatnum, stype){
                this.occupied = null;
                this.seatPos = seatnum;
                this.type = stype;
                this.activity;
            }
            function Furniture(fid, nseats, x, y, ftype, stype){
                this.furn_id = fid;
                this.num_seats = nseats;
                this.x_corr = x;
                this.y_corr = y;
                this.furn_type = ftype;
                this.seat_type = stype;
                this.seat_places;
                this.whiteboard = null;
            }
            /* MUST DEFINE A PIECE OF FURNITURE BEFORE CONSTRUCTING A SEAT */
            //Lets make our map
            var furnMap = new Map();
			
            //number of furniture to add to our map generated form our .pdo
            var furnNum = 100;
            for(i = 0; i < furnNum; i++){
                var keyString = "furnid1" //Replace this with a string generated from each row
                //will replace insertfurnhere with a string literal for each furniture type
                var insertfurnhere =  new Furniture("fid", "nseats", 1, 0, "ftype", "stype");
                //iterate through the number of seats here and populate the seat_places array with the new funcitons
                for(j = 0; j < insertfurnhere.num_seats; j++){
                    insertfurnhere.seat_places[j] = new Seat(insertfurnhere.num_seats, insertfurnhere.seat_type);
                }
                furnMap.set(keyString, insertfurnhere);
            }

		}
		
		//testing loop through each layer object
		print.onclick = function(){
			mymap.eachLayer(function (layer) { 
				if (layer.options.fid !== 0) {
					//console.log(layer.options.ftype);
					console.log(layer.toString());
				} 
			});
		}

		
		//place a draggable marker onClick!
		function onMapClick(e) {
			var furniture = document.getElementById("lay-select").elements.namedItem("furniture-select").value;
			var selectedIcon;
			var degreeOffset = document.getElementById("degree-offset").value;
			var numSeats = document.getElementById("numseats").value;
			switch(furniture){
				case "computerStation": selectedIcon=computerStation;break;
				case "collaborationStation":selectedIcon=collabStation; break;
				case "circTable":selectedIcon=circTable; break;
				case "couchThree": selectedIcon=couchThree ; break;
				case "couchCurved": selectedIcon=couchCurved ; break;
				case "couchSix": selectedIcon=couchSix ; break;
				case "couchTwo": selectedIcon=couchTwo ; break;
				case "counterCurved": selectedIcon=counterCurved; break;
				case "fitDeskEmpty": selectedIcon=fitDeskEmpty ; break;
				case "medCornerEmpty": selectedIcon=medCornerEmpty ; break;
				case "mfReaderEmpty": selectedIcon=mfReaderEmpty ; break;
				case "rectTable": selectedIcon=rectTable ; break;
				case "room": selectedIcon=roomIcon; break;
				case "seatOneSoft": selectedIcon= seatOneSoft; break;
				case "seatOne": selectedIcon= seatOne; break;
				case "studyFour": selectedIcon= studyFour; break;
				case "studyOne": selectedIcon= studyOne; break;
				case "studyThree": selectedIcon= studyThree; break;
				case "studyTwo": selectedIcon= studyTwo; break;
				case "vidViewerEmpty": selectedIcon= vidViewerEmpty; break;
				default: selectedIcon= computerStation; break;
			}
			
			var latlng = e.latlng;
			var furniture = document.getElementById("lay-select").elements.namedItem("furniture-select").value;
			

			marker = L.marker(e.latlng, {
					icon: selectedIcon,
					rotationAngle: degreeOffset,
					draggable: true,
					ftype: furniture,
					numSeats: numSeats,
					degreeOffset: degreeOffset,
					fid: 1
			}).addTo(furnitureLayer).bindPopup(e.latlng.toString()).openPopup();
			//define drag events
			marker.on('drag', function(e) {
				console.log('marker drag event');
			});
			marker.on('dragstart', function(e) {
				console.log('marker dragstart event');
				mymap.off('click', onMapClick);
			});
			marker.on('dragend', function(e) {
				//update the offset angle of a furniture object
				degreeOffset = document.getElementById("degree-offset").value;
				this.options.degreeOffset = degreeOffset;
				//set angle according to field input
				this.setRotationAngle(degreeOffset);
				
				//update latlng for insert string
				var changedPos = e.target.getLatLng();
				var lat=changedPos.lat;
				var lng=changedPos.lng;
				
				//update number of seats for furniture
				numSeats = document.getElementById("numseats").value;
				this.options.numSeats = numSeats;
				
				//generate sql insert string for furniture
				var insertString = getFurnitureString(lng,lat,degreeOffset, furniture+"_"+numSeats, "chair");
				//change popup to insertString
				this.bindPopup(insertString);
				
				//output to console to check values
				console.log('marker dragend event');
				console.log(marker.getLatLng());
				console.log(insertString);
				console.log("ftype:"+this.options.ftype);
				console.log("numSeats:"+this.options.numSeats);
				console.log("degreeOffset:"+this.options.degreeOffset);
				
				setTimeout(function() {
					mymap.on('click', onMapClick);
				}, 10);
			});
		}
			
			//bind onMapClick function
		mymap.on('click', onMapClick);
		
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