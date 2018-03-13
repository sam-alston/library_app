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
        if (!array_key_exists("username", $_SESSION)){
            ?>
            <p class="invalid-login"> Please first login before accessing the app</p>
            <?php
        }
        else{
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
        }
    ?>
    <footer class="footd">
        <p>Designed by Web App team</p>
        <p> &copy; Humboldt State University</p>
    </footer>
    </main>
    <script src="scripts/mapapp.js"></script>
</body>
</html>