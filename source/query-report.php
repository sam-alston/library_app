<?php
	//The main page for any queries that the user will grab from the DB.
	//Needs more queries such as activities, whiteboard use.
	//TODO: give a calendar view to choose the date of a survey record,
	//  Load the state of the library during that survey to give us not only area_use, but furniture location
	session_start();
    require_once('form_functions.php');
?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title> Library Query Report </title>
    <meta charset="utf-8" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.3.1/dist/leaflet.css"
    integrity="sha512-Rksm5RenBEKSKFjgI3a41vrjkw4EVPlJ3+OiI65vTjIdo9brlAacEuKOiQ5OFh7cOI1bkDwLqdLw3Zg0cRJAAQ=="
    crossorigin=""/>
    <script src="https://unpkg.com/leaflet@1.3.1/dist/leaflet.js"
    integrity="sha512-/Nsx9X4HebavoBvEBuyp3I7od5tA0UzAxs+j83KgC8PU0kgB4XiK4Lfe4y4cgBtaRJQEIFCW+oC506aPT2L1zw=="
    crossorigin=""></script>
	<script src="./javascript/report-objs-pop.js"></script>
	<script src="./javascript/leaflet.rotatedMarker.js"></script>
	<script src="./javascript/icons.js"></script>
    <link rel="stylesheet" href="styles/layout.css" type="text/css" >
    <link rel="stylesheet" href="styles/format.css" type="text/css" >
</head>
<script type="text/javascript">

    var cur_selected_date;

    $(function(){
        $('#date-select').on("change", function(){
            var form_info = document.getElementById("choose_survey_form");
            cur_selected_date = form_info.elements["date-select"].value;

            //Get rid previous select options before repopulating 
            var select = document.getElementById('survey_id_select');
            var length = select.options.length;
            if(length > 1){
                for(i = 0; i < length; i++){
                    select.remove(1);
                }
            }
			$.ajax({
                url: 'phpcalls/get-survey-ids.php',
                type: 'get',
                data:{ 'selected_date': cur_selected_date },
                success: function(data){

                    console.log("got dates");
                    var json_object = JSON.parse(data);
                    var survey_select = document.getElementById('survey_id_select');

                    for(var i = 0; i < json_object.length; i++){
                        var obj = json_object[i];
                        surv_id = obj['survey_id'];
                        lay_id = obj['layout_id'];
                        var option = document.createElement('option');
                        option.value = surv_id;
                        option.innerHTML = "Survey: " + surv_id +" for Layout" + lay_id;
                        survey_select.appendChild(option);
                    }
                }
            });
			
        });
    });
</script>
<body>
    <header>
        <img class="logo" src="images/hsu-wm.svg">
        <h1>Library Data Collector</h1>
    
    
        <?php
            if (!array_key_exists("username", $_SESSION)){
                ?>
                <p class="invalid-login"> Please first <a href="index.php">login</a> before accessing the app</p>
                <?php
            }
            else{
                 ?>
                <nav>
                    <p class="nav"><a href="home.php">Home</a></p>
                    <p class="nav"><a href="data-collection.php">Data Collection</a></p>
                    <p class="nav selected"><a href="query-report.php">Query Report</a></p>
                    <p class="nav"><a href="editor.php">Create A Layout</a></p>
                    <p class="nav"><a href="logout.php">Logout</a></p>
                </nav>
    </header>
    <main>
        <h2><?= $_SESSION["username"]?> what shall we query today? </h2>
        <form class="report-selector" id="choose_survey_form">
            <fieldset>
                <!--THIS IS A PLACEHOLDER! SELECT WILL BE POPULATED BY DATES FROM DB-->
                <select name="date" id="date-select">
                    <option value="0">Choose a Date</option>
                    <?php
                    get_dates_options();
                    ?>
                </select>
                <!--THIS IS A PLACEHOLDER! SELECT WILL BE POPULATED BY TIMES FROM DB-->
                <select name="survey_id" id="survey_id_select">
                    <option value="">Choose a Survey</option>
                </select>

                <input type="submit" name="submit-query" />
            </fieldset>
        </form>
                <?php
            }
        ?>
		
		<div id="mapid"></div>
		<div id="reportDiv"></div>
		<?php
        if (array_key_exists("username", $_SESSION)){
            ?>
            <h3 class="log-state"> Logged In: <?= $_SESSION["username"]?> </h3>
            <?php
        }
		
		if (array_key_exists("survey_id", $_GET)){
			?>
			<script>
				//create maps and grab survey_id
				var survey_id = <?= $_GET["survey_id"] ?>;
				
				areaMap = new Map();
				furnMap = new Map();
				
				//define objects
				function Area(area_id, verts, area_name){
					this.area_id = area_id;
					this.verts = verts;
					this.area_name = area_name;
					this.occupants = 0;
					this.seats = 0;
				}
				function Verts(x,y, order){
					this.x = x;
					this.y = y;
					this.order = order;
				}
				function Furniture(fid, numSeats, x, y, degreeOffset, ftype, inArea, occupants, activities){
					this.fid = fid;
					this.numSeats = numSeats;
					this.x = x;
					this.y = y;
					this.degreeOffset = degreeOffset;
					this.ftype = ftype;
					this.inArea = inArea;
					this.occupants = occupants;
					this.activities = activities;
				}
				function Activity(count, name){
					this.count = count;
					this.name = name;
				}
				
				//popuate furnMap and areaMap then place on map
				populateObjs(survey_id);
			
			
			//make map
			var mymap = L.map('mapid', {crs: L.CRS.Simple});
			var areaLayer = L.layerGroup().addTo(mymap);
			var furnitureLayer = L.layerGroup().addTo(mymap);
			var bounds = [[0,0], [360,550]];

			mymap.fitBounds(bounds);
			
			
			
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
			<?php
		}
    ?>
    </main>
    <footer>
        <p>Designed by Web App team</p>
        <p> &copy; Humboldt State University</p>
    </footer>
</body>
</html>