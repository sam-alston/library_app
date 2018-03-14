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
</head>
<body>
    <header>
        <img class="logo" src="images/hsu-wm.svg">
        <h1>Library Data Collector</h1>
    </header>
    <?php
        if (array_key_exists("username", $_SESSION)){
            ?>
            <h3 class="log-state"> Logged In: <?= $_SESSION["username"]?> </h3>
            <?php
        }
    ?>
    
    <main>
    <?php
        /*if (!array_key_exists("username", $_SESSION)){
            ?>
            <p class="invalid-login"> Please first <a href="index.php">login</a> before accessing the app</p>
            <?php
        } 
        else{*/
             ?>
            <nav>
                <p class="nav"><a href="home.php">Home</a></p>
                <p class="nav selected"><a href="data-collection.php">Data Collection</a></p>
                <p class="nav"><a href="query-report.php">Query Report</a></p>
                <p class="nav"><a href="editor.php">Create A Layout</a></p>
                <p class="nav"><a href="logout.php">Logout</a></p>
            </nav>

            <form class="layout-selector" id="lay-select">
                <fieldset>
                    <select name="floor-select">
                        <option value="default">Choose a Floor</option>
                        <option value="floorplan.svg">Floor 1</option>
                        <option value="hsu-wm.svg">Floor 2</option>
                        <option value="f3">Floor 3</option>
                    </select>
                    <select name="layout-select">
                        <!--REPLACE THIS PLACEHOLDER SELECT WITH SELECT POPULATED BY PREVIOUS SELECTION layoud -->
                        <option value="default">Choose a Layout</option>
                        <option value="lay-1">Layout 1</option>
                        <option value="lay-2">Layout 2</option>
                    </select>
                    <button type="button" id="sub_layout">Submit </button>
                </fieldset>
            </form>
            <span id="text">_____</span>
            <div id="mapid"></div>
            <?php
        /*}*/
    ?>
    <footer class="footd">
        <p>Designed by Web App team</p>
        <p> &copy; Humboldt State University</p>
    </footer>
    </main>
    <script>
        
        //generates a map location
        var submit = document.getElementById("sub_layout");
        var floor_image = "local";
        var s_layout = "local";
        var mymap = L.map('mapid', {crs: L.CRS.Simple});
        var bounds = [[0,0], [360,550]];
        var image;
        mymap.fitBounds(bounds);

        submit.onclick = function(){
            if( mymap.hasLayer(image)){
                mymap.removeLayer(image);
            }
            var form_info = document.getElementById("lay-select");
            var test =  document.getElementById("text");
            floor_image = form_info.elements["floor-select"].value;
            s_layout = form_info.elements["layout-select"].value;
            test.innerHTML = floor_image;
            image = L.imageOverlay('../web_mockup_1/images/' + String(floor_image), bounds).addTo(mymap);

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

            //add areas based on info from .pdo file from string literals

            //this is an example
            var marker = L.marker([51.5, -0.09]).addTo(mymap);

            var polygon1 = L.polygon([
                [90, 10],
                [90, 170],
                [320, 170],
                [320, 10]
            ]).addTo(mymap);

            polygon1.bindPopup("This is the dining room");

        };
    </script>
</body>
</html>