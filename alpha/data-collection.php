<?php
    session_start();
?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title> Library Collect Data </title>
    <meta charset="utf-8" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <link rel="stylesheet" href="normalize.css" type="text/css" >
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
                        <button type="button" id="sub_layout">Submit</button>
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
        var floor_image = "local";
        var s_layout = "local";
        var mymap = L.map('mapid', {crs: L.CRS.Simple});
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
			/*
            //add areas based on info from .pdo file from string literals
            //this is an example
			var drawnItems = new L.FeatureGroup();
			mymap.addLayer(drawnItems);

			var polyLayers = floorOnePolys();
    // Add the layers to the drawnItems feature group 
    for(layer of polyLayers) {
        drawnItems.addLayer(layer); 
    }*/
	
			switch(floorIMGstr){
				case "floor1.svg": addFloorOneAreasTo(mymap, drawnItems); break;
				case "floor2.svg": addFloorTwoAreasTo(mymap, drawnItems); break;
				case "floor3.svg": addFloorThreeAreasTo(mymap, drawnItems); break;
			}			
			
		}
		
		var marker;
		var latlng;
		function onMapClick(e) {
			latlng = e.latlng;
				marker = L.marker(e.latlng, {icon: computerStation }).addTo(furnitureLayer).bindPopup("I am a Computer Station.");
			}
		mymap.on('click', onMapClick);
		
		//On zoomend, resize the marker icons
		mymap.on('zoomend', function() {
			//alert(mymap.getZoom)());
			var newzoom = '' + (2*(mymap.getZoom())) +'px';
			//marker = L.marker(e.latlng, {icon: couchFour }).addTo(furnitureLayer).bindPopup("I am a Computer Station.");
			$('#mymap .furnitureicon').css({'width':newzoom,'height':newzoom});
			//alert(newzoom);
		});
    </script>
</body>
</html>