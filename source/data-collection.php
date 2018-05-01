<?php
	//Data-collection loads layouts from selected floors. A chosen layout will populate a map, its areas, and furniture layout
	//to a leaflet map, storing areas in an areaMap, furniture in a furnMap.
	//TODO: move functions out of data-collection to separate files.
    session_start();
	require_once('./config.php');
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
    <script src="./javascript/icons.js"></script>
    <script src="./javascript/layoutFunction.js"></script>
    <script src="./javascript/leaflet.rotatedMarker.js"></script>
    <script src="./javascript/submit_survey.js"></script>
    <script src="./javascript/make_popup.js"></script>
    <script src="./javascript/pop-activities.js"></script>
    <script src="./javascript/add-areas.js"></script>
    <script src="./javascript/markerInPoly.js"></script>
    <!--script for updating furniture location in DB -->
    <script src="./javascript/updateFurn.js"></script>
    <script src="./javascript/get_layouts.js"></script>
    <script src="./javascript/map_helpers.js"></script>
    <script src="./javascript/helpers.js"></script>
    <script src="./javascript/build_markers.js"></script>
    <script type="text/javascript" async>
    //define our object here
    
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
		$dbh = new PDO($dbhost, $dbh_select_user, $dbh_select_pw);

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
                <div id="wb_div"></div>
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

        var image;
        var selected_furn;
		var selected_marker;
        var seat_num;
		    //to store the seat_places array to be saved
	    var temp_seat_places = [];
	    var whiteboard_activity = "0";

        var mymap = L.map('mapid', {crs: L.CRS.Simple});
        var areaLayer = L.layerGroup().addTo(mymap);
        var furnitureLayer = L.layerGroup().addTo(mymap);
        var bounds = [[0,0], [360,550]];

        mymap.fitBounds(bounds);

        var furnMap = new Map();
        var activityMap = new Map();
        var wb_activityMap = new Map();
        var areaMap = new Map();

        var popup = document.getElementById("popupTest");

        var popupDim = 
        {
            'maxWidth': '5000',
            'maxHeight': '5000'
        };//This is the dimensions for the popup

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
            this.whiteboard = [];
            this.totalOccupants = 0;
            this.marker;
            this.modified = false;
            this.degreeOffset = 0;
            this.x;
            this.y;
            this.ftype;
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
                build_markers(layout);
            <?php
            }
        ?>
            createAreas(layout);
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

    </script>
</html>
