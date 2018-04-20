<?php
	session_start();
	require_once('./config.php');

	//initilize an admin account for only those who know it to access it
?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<!--
	Reach Text Page with Oracle:
	http://nrs-projects.humboldt.edu/~bam22/LibraryAppTest/index.php
-->
<head>
    <title> Library Login </title>
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
    <main class="login_main">
    	<?php
    	  if ( !array_key_exists("username_in", $_POST)){
    	  	?>
			    <form class="login" action="<?= htmlentities($_SERVER['PHP_SELF'], ENT_QUOTES) ?>" method="post">
			    	<fieldset >
			    		<legend>Please Enter App Login</legend>
			    		<label for="username_in">Username: </label>
			    		<input type="text" name="username_in" required="required">
			    		<label for="password_in">Password: </label>
			    		<input type="password" name="password_in" required="required">
			    		<input type="submit" name="submit_login" value="Log In">
			    	</fieldset>
			    </form>
			<?php
			}
			else
			{
			    
			    $username = strip_tags($_POST['username_in']);
			    $password = $_POST['password_in'];
			    $author = "has no value";

			    if($username == "admin" && $password == "gdc4562" ){

			    // set up db connection string THIS WILL BE REPLACED WITH HUMBOLDT ACCOUNT INFORMATION
			    

			    try{
				    $dbh = new PDO($dbhost, $dbh_select_user, $dbh_select_pw);
				    foreach($dbh->query('SELECT * from furniture') as $row) {
				        print_r($row);
				    }
				    $dbh = null;
					}
				catch (PDOException $e){
					    print "Error!: " . $e->getMessage() . "<br/>";
					    die();
				}
			
				//if I reach here, I have connected to my username and password, and can now travel to the next page and store session variables
				$_SESSION["username"] = $username;
				$_SESSION["password"] = $password;
				$_SESSION["dbc"] = $dbh;
				$_SESSION["author"] = $author;
				header("Location:home.php");
			    }
			    else{
			    	?>
			    	<p>You have entered the wrong login, please try again</p>
			    	<a href="logout.php">Try Again</a>
			    	<?php
			    }

			}
			?>
    </main>
    <footer>
        <p>Designed by HSU Library Web App team. &copy; Humboldt State University</p>
    </footer>
</body>
</html>