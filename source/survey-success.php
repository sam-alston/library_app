<?php
	//Survey successfully submitted, display message to user of Success.
	//Routed here from data-collection.php on survey submit
	//TODO: add a button to make another survey, perhaps let us choose the floor and layout and send us
	//to data-collection with that in GET array to immediately load a new floor to survey.
    session_start();
?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title> Library Collect Data </title>
    <meta charset="utf-8" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="./javascript/get_layouts.js"></script>
    <link rel="stylesheet" href="normalize.css" type="text/css" >
    <link rel="stylesheet" href="styles/layout.css" type="text/css" >
    <link rel="stylesheet" href="styles/format.css" type="text/css" >
</head>
<body>
    <header>
        <img class="logo" src="images/hsu-wm.svg">
        <h1>Library Data Collector</h1>
    
    <?php
        if (array_key_exists("username", $_SESSION)){
            ?>
            <h3 class="log-state"> Logged In: <?= $_SESSION["username"]?> </h3>
            <?php
        }
    ?>
    
    
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
                <p class="nav"><a href="query-report.php">Query Report</a></p>
                <p class="nav"><a href="editor.php">Create A Layout</a></p>
                <p class="nav"><a href="logout.php">Logout</a></p>
            </nav>
    </header>
    <main>
        
        <form method="post" action="data-collection.php" class="layout-selector" id="lay-select">
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
        
        <h2>Success <?= $_SESSION["username"]?>, your survey has been recorded and saved to the database</h2>

    </main>  
         

    
            <?php
        }
    ?>
    
    <footer>
        <p>Designed by HSU Library Web App team. &copy; Humboldt State University</p>
    </footer>
</body>
</html>