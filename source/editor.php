<?php
	//In this file, the core structure of editing a layout is implemented.
    session_start();
	require_once('./config.php');
?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title> Layout Editor </title>
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
   <script src="./javascript/icons.js"></script>
   <script src="./javascript/layoutFunction.js"></script>
   <script src="./javascript/leaflet.rotatedMarker.js"></script>
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
                <p class="nav"><a href="data-collection.php">Data Collection</a></p>
                <p class="nav"><a href="query-report.php">Query Report</a></p>
                <p class="nav selected"><a href="editor.php">Create A Layout</a></p>
                <p class="nav"><a href="logout.php">Logout</a></p>
            </nav>
            <main class="to-top">
                <form class="layout-selector" id="lay-select">
                    <fieldset>
                        <!-- Choose the floor to work from-->
                        <select name="floor-select">
                            <option value="default">Choose a Floor</option>
                            <option value="floor1.svg">Floor 1</option>
                            <option value="floor2.svg">Floor 2</option>
                            <option value="floor3.svg">Floor 3</option>
                        </select>
						<button type="button" id="sub_layout">Submit</button>
						</br></br>
						<!--select a piece of furniture to place -->
						<label>Select a piece of furniture:</label>
						</br>
						<select name="furniture-select" >
							<?php
								//get furniture types to populate dropdown for placing on map
								$dbh = new PDO($dbhost, $dbh_select_user, $dbh_select_pw);
								
								$fTypeSelectStmt = $dbh->prepare("SELECT * FROM furniture_type");
								$fTypeSelectStmt->execute();
								$furnitureTypes = $fTypeSelectStmt->fetchAll();
								
								foreach($furnitureTypes as $row) {
							?>
							<option value=<?= $row['furniture_type_id'] ?>> <?= $row['furniture_name'] ?> </option>
							<?php
								}
							?>
						</select>
						</br></br>
						
                        
						<button type="button" id="printfurn" >Print Furn</button>
                    </fieldset>
                </form>
				<!--Create div for the popup -->
				<div id="popupHolder"><div id="popup"></div></div>
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
		
        var mymap = L.map('mapid', {crs: L.CRS.Simple, minZoom: 0, maxZoom: 4});
		var furnitureLayer = L.layerGroup().addTo(mymap);
		var drawnItems = new L.FeatureGroup();
        var bounds = [[0,0], [360,550]];
		mymap.fitBounds(bounds);
		
		var selected_marker;
		var selected_furn;
		
		//container for furniture objects
        var furnMap = new Map();
		var mapKey = 0;
		
		//floor image placed from dropdown selection	
        var image;
        
		//define our furniture object here
		function Furniture(id,ftype, latlng, fname){
			this.id = id;
			this.fname = fname;
			this.marker;
			this.degreeOffset = 0;
			this.x = latlng.lng;
			this.y = latlng.lat;
			this.ftype = ftype;
		}
		
        submit.onclick = function(){
            //remove old floor image and place newly selected floor image
            if( mymap.hasLayer(image)){
                mymap.removeLayer(image);
            }
            var form_info = document.getElementById("lay-select");
            floor_image = form_info.elements.namedItem("floor-select").value;
           
			floorIMGstr = String(floor_image);
            image = L.imageOverlay('./images/' + floorIMGstr, bounds).addTo(mymap);
            
        }
		
		//testing loop through each layer object
		print.onclick = function(){
			furnMap.forEach(function(value, key, map){
				console.log(value.fname);
			});
		}

		
		//place a draggable marker onClick!
		function onMapClick(e) {
			var furn = document.getElementById("lay-select").elements.namedItem("furniture-select");
			var ftype = furn.value;
			var findex = furn.selectedIndex;
			var furnOption = furn.options;
			var fname = furnOption[findex].text;
			//convert the string furniture type into an int to send to getIconObj(int ftype)
			ftype = parseInt(ftype);
			
			var selectedIcon = getIconObj(ftype);
					
			var latlng = e.latlng;
			
			//create the furniture object and store in map
			var newFurn = new Furniture(mapKey, ftype, latlng, fname);
			furnMap.set(mapKey, newFurn);
			if(document.getElementById("popup") == null){
					popupDiv = document.createElement("DIV");
					popupDiv.id = "popup";
					document.getElementById("popupHolder").appendChild(popupDiv);
			}
			
			var popup = document.getElementById("popup");
			var popupDim = 
			{
				'minWidth': '200',
				'minHeight': '2000px',
			};//This is the dimensions for the popup
			
			marker = L.marker(e.latlng, {
					fid: mapKey++,
					icon: selectedIcon,
					rotationAngle: 0,
					draggable: true
			}).addTo(furnitureLayer).bindPopup(popup,popupDim);
			//give it an onclick function
			 marker.on('click', markerClick);
			
			//define drag events
			marker.on('drag', function(e) {
				console.log('marker drag event');
			});
			marker.on('dragstart', function(e) {
				console.log('marker dragstart event');
				mymap.off('click', onMapClick);
			});
			marker.on('dragend', function(e) {
				//update latlng for insert string
				var changedPos = e.target.getLatLng();
				var lat=changedPos.lat;
				var lng=changedPos.lng;		
				
				//generate sql insert string for furniture
				//var insertString = getFurnitureString(lng,lat,degreeOffset, furniture+"_"+numSeats, "chair");
				//change popup to insertString
				//this.bindPopup(insertString);
				
				//output to console to check values
				console.log('marker dragend event');
				
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
		
		function markerClick(e){
			//when a marker is clicked, it should be rotatable, and delete able
			selected_marker = this;
			selected_furn = furnMap.get(selected_marker.options.fid);
			//make sure the nameDiv is created and attached to popup
			if(document.getElementById("nameDiv") == null){
				var nameDiv = document.createElement("div");
				nameDiv.id = "nameDiv";
				document.getElementById("popup").appendChild(nameDiv);	
			}
			//set the nameDiv to the name of the current furniture
			var nameDiv = document.getElementById("nameDiv");
			nameDiv.innerHTML = "<strong>Type: </strong>"+selected_furn.fname+"</br></br>";
			
			if(document.getElementById("deleteButtonDiv") == null) {
				//create a div to hold delete marker button
				var deleteButtonDiv = document.createElement("div");
				deleteButtonDiv.id = "deleteButtonDiv";
				//attach deleteButton div to popup
				document.getElementById("popup").appendChild(deleteButtonDiv);
				//create delete button
				var deleteMarkerButton = document.createElement("BUTTON");
				deleteMarkerButton.id = "deleteMarkerButton";
				deleteMarkerButton.innerHTML = "Delete";
				deleteMarkerButton.onclick = deleteHelper;
				//deleteMarkerButton.className = "deleteButton";
				//add the button to the div
				document.getElementById("deleteButtonDiv").appendChild(deleteMarkerButton);
			}
			
			//check if the rotateDiv has been made
			if(document.getElementById("rotateDiv") == null){
				//create a div to hold rotateButton
				var rotateDiv = document.createElement("div");
				rotateDiv.id = "rotateDiv";
				//attach the rotatebutton div to the popup
				document.getElementById("popup").appendChild(rotateDiv);
				rotateHelper();
			}			
		}
		
		//deletes the selected marker
		function deleteHelper()
		{
			//remove marker
			mymap.removeLayer(selected_marker);
			//remove furniture from furnMap
			furnMap.delete(selected_furn.id);
		}
		
		//rotates the selected marker
		function rotateHelper()
        {
        	if(document.getElementById("rotateSlider") == null)
        	{
        		var rotateSlider = document.createElement("input");
        		rotateSlider.type = "range";
        		rotateSlider.min = "-180";
        		rotateSlider.max = "180";
        		rotateSlider.value = "0";
        		rotateSlider.step = "15";
        		rotateSlider.id = "rotateSlider";
				rotateSlider.value = selected_furn.degreeOffset;
        		
        		var sliderValue = document.createElement("p");
        		sliderValue.id = "sliderValue";
        		sliderValue.innerHTML = "<strong>Offset: </strong>"+selected_furn.degreeOffset;
        		
        		rotateDiv = document.getElementById("rotateDiv");
				rotateDiv.appendChild(sliderValue);
        		rotateDiv.appendChild(rotateSlider);
        	
        			
        		rotateSlider.oninput = function()
        		{
        			selected_marker.setRotationOrigin("center");
					selected_furn.degreeOffset =rotateSlider.value;
        			selected_marker.options.degree_offset = rotateSlider.value;
        			selected_marker.setRotationAngle(rotateSlider.value);
        			sliderValue.innerHTML = "<strong>Offset: </strong>" + rotateSlider.value;
        		}
        	}
        	
        	else
        	{
        		document.getElementById("rotateSlider").remove();
        		document.getElementById("sliderValue").remove();
        	}
			

        
        }
    </script>
</body>
</html>