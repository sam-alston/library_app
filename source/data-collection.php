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
   <script src="./scripts/floor1.js"></script>
   <script src="./scripts/floor2.js"></script>
   <script src="./scripts/floor3.js"></script>
   <script src="./javascript/get_layouts.js"></script>
   <script src="./javascript/icons.js"></script>
   <script src="./javascript/layoutFunction.js"></script>
   <script src="./javascript/leaflet.rotatedMarker.js"></script>
   <script src="./javascript/submit_survey.js"></script>
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
        if(array_key_exists('floor-select', $_POST)){
            /*********To Be Replaced with form function*********/
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
            /*******End of Replace select with form function********/
        }
        /*Builds only floor select if no floor is stored*/
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
        /*Create the div container for the map*/
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
        var furnitureLayer = L.layerGroup().addTo(mymap);
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
        function Furniture(fid){
            this.furn_id = fid;
            this.seat_places = [];
            this.whiteboard = 0;
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
                    var newFurniture = new Furniture( <?php echo $row['furniture_id'] ?>);

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
                    }).addTo(furnitureLayer).bindPopup(keyString);


                    /*TODO: Seat's made on survey, not furniture creation*/
                    /*for(i = 0; i < newFurniture.num_seats; i++){
                        newFurniture.seat_places[i] = new Seat(i, newFurniture.seat_type);
                    }*/

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
            //marker = L.marker(e.latlng, {icon: couchFour }).addTo(furnitureLayer).bindPopup("I am a Computer Station.");
            $('#mapid .furnitureIcon').css({'width':newzoom,'height':newzoom});
            $('#mapid .furnitureLargeIcon').css({'width':newLargeZoom,'height':newLargeZoom});          
        });
        //On click of submission, Create's a Survey Record and Inserts each seat object into the database with that ID
        function submitSurveyHelper(){
            var username = "<?php echo $_SESSION['username']?>";
            var layout = "<?php echo $_POST['layout-select']?>";

            submitSurvey(username, layout, furnMap);
        }
    </script>
</html>