<?php
	//This is the page for creating and editing layouts.
	//TODO: add editor from alpha directory to editor
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
                <p class="nav selected"><a href="editor.php">Create A Layout</a></p>
                <p class="nav"><a href="logout.php">Logout</a></p>
            </nav>
    </header>
    <main>
            <h2><?= $_SESSION["username"]?> this is a placeholder for the layout editor </h2>
            <?php
        }
    ?>
    </main>
    <footer>
        <p>Designed by HSU Library Web App team. &copy; Humboldt State University</p>
    </footer>
</body>
</html>