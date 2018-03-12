<?php
	session_start();
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
			    		<legend>Please Enter Humboldt(Oracle) Login</legend>
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

			    // set up db connection string THIS WILL BE REPLACED WITH HUMBOLDT ACCOUNT INFORMATION
			    $db_conn_str = "(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)
			                                   (HOST = cedar.humboldt.edu)
			                                   (PORT = 1521))
			                        (CONNECT_DATA = (SID = STUDENT)))";
			    $conn = oci_connect($username, $password, $db_conn_str);
			    if (! $conn)
        		{
					?>
					<p> Could not log into Oracle, sorry. </p>
					<footer>
					    <p>Designed by Web App team</p>
					    <p>	&copy; Humboldt State University</p>
					</footer>
	</main>
</body>
</html>
					<?php
					exit;
				}
				//if I reach here, I have connected to my username and password, and can now travel to the next page and store session variables
				$_SESSION["username"] = $username;
				$_SESSION["password"] = $password;
				header("Location:home.php");
			}
			?>
    </main>
    <footer>
        <p>Designed by Web App team</p>
        <p>	&copy; Humboldt State University</p>
    </footer>
</body>
</html>