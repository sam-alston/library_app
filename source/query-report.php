<?php
    session_start();
?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title> Library Query Report </title>
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
                    <p class="nav"><a href="data-collection.php">Data Collection</a></p>
                    <p class="nav selected"><a href="query-report.php">Query Report</a></p>
                    <p class="nav"><a href="editor.php">Create A Layout</a></p>
                    <p class="nav"><a href="logout.php">Logout</a></p>
                </nav>
                <h2><?= $_SESSION["username"]?> what shall we query today? </h2>
                <form class="report-selector">
                    <fieldset>
                        <!--THIS IS A PLACEHOLDER! SELECT WILL BE POPULATED BY DATES FROM DB-->
                        <select name="date">
                            <option value="">Choose a Date</option>
                            <option value="d1">Date 1</option>
                            <option value="d2">Date 2</option>
                            <option value="d3">Date 3</option>
                        </select>
                        <!--THIS IS A PLACEHOLDER! SELECT WILL BE POPULATED BY TIMES FROM DB-->
                        <select name="time">
                            <option value="">Choose a Time</option>
                            <option value="time-1">Time 1</option>
                            <option value="time-2">Time 2</option>
                            <option value="time-3">Time 3</option>
                            <option value="time-4">Time 4</option>
                        </select>
                        <!--THIS IS A PLACEHOLDER! SELECT WILL BE POPULATED BY TIMES FROM DB-->
                        <select name="floor">
                            <option value="">Choose a Floor</option>
                            <option value="f1">Floor 1</option>
                            <option value="f2">Floor 2</option>
                            <option value="f3">Floor 3</option>
                        </select>
                        <input type="submit" name="submit-query" />
                    </fieldset>
                </form>
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