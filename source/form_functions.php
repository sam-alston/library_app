<?php
	/*These functions build HTML form elements used for the collection of data and navigation*/

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

	/*function form_lay_selct(){
		?>
			<form class="layout-selector" id="lay-select">
	            <fieldset>
	                <!-- Set up a Query here to add options for each layout based on what floors are available in the databse-->
	                <select name="floor-select" id="floor-select">
	                    <option value="default">Choose a Floor</option>
	                    <option value="1">Floor 1</option>
	                    <option value="2">Floor 2</option>
	                    <option value="3">Floor 3</option>
	                </select>
	                <select name="layout-select">
	                    <!-- Populate these options with those from the database-->
	                    <option value="default">Choose a Layout</option>
	                    <?php
	                        //Will replace hardcoded floor with ajax statement to get floor when floor changes
	                        foreach($dbh->query('SELECT * FROM layout WHERE floor = "1"') as $row){
	                            ?> <option value="<?= $row['layout_id'] ?>">Layout <?= $i ?> for Layout ID: <?= $row['layout_id'] ?> </option> <?php
	                        }
	                    ?>
	                </select>
	                <button type="button" id="sub_layout">Load</button>
	            </fieldset>
	        </form>
		<?php
	}*/

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