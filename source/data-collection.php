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
    <?php
        require_once('form_functions.php');
    ?>
</head>

<body>
    <button class="hide_nav" id="nav_toggle">&plus;</button>
    <button class="submit_survey hidden" id="submit_survey" onclick="if(confirm('Are you sure you want to submit this survey?')) submitSurvey();">Submit Survey</button>
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
        nav_form();
        $dbh = new PDO('mysql:host=localhost;dbname=hsu_library;charset=utf8mb4', 'root', '');

        //$stmt1 = $dbh->query("SELECT floor FROM layout where floor = /*insert floor selected here */");
        /*statment for after layout is selected*/

        //$stmt2 = $dbh->query("SELECT layout_image FROM layout where layout_id = /*Selected Layout*/");

        if(array_key_exists('floor-select', $_POST)){
            $_SESSION['cur_floor'] = $_POST['floor-select'];
            ?>
            <main class="to-top">
            <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" class="layout-selector" id="lay-select">
                <fieldset>
                    <select name="floor-select" id="floor-select">
                        <option value="0">Choose a Floor</option>
                        <option value="1" selected="selected">Floor 1</option>
                        <option value="2">Floor 2</option>
                        <option value="3">Floor 3</option>
                    </select>
                    <select name="layout-select">
                        <!-- Populate these options with those from the database-->
                        <option value="default">Choose a Layout</option>
                        <?php
                            //Will replace hardcoded floor with ajax statement to get floor when floor changes
                            $i = 1;
                            foreach($dbh->query('SELECT * FROM layout WHERE floor = '.$_SESSION['cur_floor']) as $row){
                                ?> <option value="<?= $row['layout_id'] ?>">Layout <?= $i ?> for Layout ID: <?= $row['layout_id'] ?> </option><?php
                                $i++;
                            }
                        ?>
                    </select>
                    <input type="submit" id="sub_layout" value="Load Layout"/>
                </fieldset>
            </form>
            <?php
        }
        else{
            ?>
            <main class="to-top">
            <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" class="layout-selector" id="lay-select">
                <fieldset>
                    <!-- Set up a Query here to add options for each layout based on what floors are available in the databse-->
                    <select name="floor-select" id="floor-select">
                        <option value="0">Choose a Floor</option>
                        <option value="1">Floor 1</option>
                        <option value="2">Floor 2</option>
                        <option value="3">Floor 3</option>
                    </select>
                    <input type="submit" id="sub_layout" value="Load Floor"/>
                </fieldset>
            </form>
            <?php
        }
        ?>
        
            <div id="mapid"></div>
                <?php
            }
        ?>
            <footer class="footd foot_hide">
                <p>Designed by HSU Library Web App team. &copy; Humboldt State University</p>
            </footer>
        </main>
    </body> 
    <script>
        //generates a map location
        var submit = document.getElementById("sub_layout");
        var floor_image = "local";
        var s_layout = "local";
        var mymap = L.map('mapid', {crs: L.CRS.Simple});
        var bounds = [[0,0], [360,550]];
        mymap.fitBounds(bounds);
        var image;
        var furnMap = new Map();

        //define our object here
        function Seat(seatnum, stype){
            this.seatPos = seatnum;
            this.type = stype;
            this.activity;
            this.occupied = 0;
        }
        function Furniture(fid, nseats, x, y, offset, ftype, stype){
            this.furn_id = fid;
            this.num_seats = nseats;
            this.x_corr = x;
            this.y_corr = y;
            this.offset = offset;
            this.furn_type = ftype;
            this.seat_type = stype;
            this.seat_places = [];
            this.whiteboard = 0;
        }

        $(function(){
            $('#floor-select').change( function(){
                var form_info = document.getElementById("floor-select");
                var choose_floor = form_info.value;
                $.ajax({
                    url: 'floor-select.php',
                    type: 'get',
                    data:{
                        'floor_ID': choose_floor
                    },
                    success: function(data){
                        console.log("success, ajax ran got session variable: ");
                    }
                });
            });
        });

        $(document).ready(function(){
            //Test using layout in localhost with .PDO connection ect.
            if( mymap.hasLayer(image)){
                mymap.removeLayer(image);
            }
            var form_info = document.getElementById("lay-select");
            floor_image = "<?php echo $_SESSION['cur_floor'] ?>";
            s_layout = form_info.elements["layout-select"].value;
            floorIMGstr = String(floor_image);
            alert(floorIMGstr);
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
            if(array_key_exists("layout-select", $_POST)){
                $_SESSION['cur_layout'] = $_POST['layout-select'];

                $getfurn = $dbh->prepare('SELECT * FROM furniture WHERE layout_id = :set_layout');

                $test_var = $_POST["layout-select"];

                $getfurn->bindParam(':set_layout', $test_var, PDO::PARAM_INT);

                $getfurn->execute();

                ?>

                console.log('Prepared Select stament and executed statement');

                <?php
                foreach ($getfurn as $row) {
                    //seperate query to get num seats based on furniture

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
                    var length = furnMap.size;

                    <?php
                }
                ?>

                //place a marker for each furniture item
                var iterateMap = furnMap.values();
                for(var i of furnMap){
                    var cur_furn = iterateMap.next().value;
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
                    var popup = '<iframe id="iframe" src="./popup.html"/>';
                    
                    //This is the dimensions for the popup
                    var popupDim = 
                    {
                        'maxWidth': '5000',
                        'maxHeight': '5000'
                    }
                    

                    L.marker(cur_mark, {icon: selectedIcon}).addTo(mymap).setRotationAngle(offset).bindPopup(popup, popupDim);
                }

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

            /*function onMapClick(e) {
                alert("You clicked the map at " + e.latlng);
            }
            mymap.on('click', onMapClick);*/
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
            //marker = L.marker(e.latlng, {icon: couchFour }).addTo(furnitureLayer).bindPopup("I am a Computer Station.");
            $('#mapid .furnitureIcon').css({'width':newzoom,'height':newzoom});
            $('#mapid .furnitureLargeIcon').css({'width':newLargeZoom,'height':newLargeZoom});          
        });

        function submitSurvey(){
            var cur_survey_id;
            console.log("You are submitting the survey");
            /* Insert statment for Survey ID */
            var username = "<?php echo $_SESSION['username']?>";
            var layout = "<?php echo $_POST['layout-select']?>";
            $.ajax({
                url: 'create_survey_record.php',
                type: 'get',
                data:{
                    'username': username,
                    'layout': layout,
                    'survey_id': cur_survey_id
                },
                success: function(data){
                    console.log("Inserted New Survey Record");
                    /*Get that new Survey ID for insertion statements*/
                    var json_object = JSON.parse(data);
                    cur_survey_id = json_object.s_id;
                    var iterateMap = furnMap.values();
                    for(var i of furnMap){
                        var cur_furn = iterateMap.next().value;
                        for(var j = 0; j < cur_furn.num_seats; j++){
                            var cur_seat = cur_furn.seat_places[j];
                             /* Run insert statment for each seat*/
                            $.ajax({
                                url: 'insert-seat.php',
                                type: 'post',
                                data:{
                                    'furn_id': cur_furn.furn_type,
                                    'occupied': cur_seat.occupied,
                                    'seat_pos': cur_seat.seatPos,
                                    'seat_type': cur_seat.type,
                                    'survey_id': cur_survey_id
                                },
                                success: function(data){
                                    console.log("Seat was inserted ");
                                }
                            });
                        }
                    }
                }
            });

           

            
        };

    </script>
</html>