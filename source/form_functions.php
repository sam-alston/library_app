<?php
	/*These functions build HTML form elements used for the collection of data and navigation*/
	//navigation buttons
	function nav_form(){
		?>
			<nav class="hidden">
	            <p class="nav"><a href="home.php">Home</a></p>
	            <p class="nav selected"><a href="data-collection.php">Data Collection</a></p>
	            <p class="nav"><a href="query-report.php">Query Report</a></p>
	            <p class="nav"><a href="editor.php">Create A Layout</a></p>
	            <p class="nav"><a href="logout.php">Logout</a></p>
	        </nav>
        <?php
	}

	//selects the dates of survey records
	function get_dates_options(){
		require_once('config.php');
		//get activities and populate activityMap
		$dbh = new PDO($dbhost, $dbh_select_user, $dbh_select_pw);

		$getDates = $dbh->prepare('SELECT DISTINCT CONVERT(survey_date, DATE) as date_surveyed FROM survey_record');

		if($getDates->execute()){
			while($row = $getDates->fetch(PDO::FETCH_ASSOC)){
				?>
				<option value="<?= $row['date_surveyed'] ?>"> Survey's for: <?= $row['date_surveyed'] ?> </option>
				<?php
			}
		}
	}
?>