<?php
	//The main page for any queries that the user will grab from the DB.
	//Needs more queries such as activities, whiteboard use.
	//TODO: give a calendar view to choose the date of a survey record,
	//  Load the state of the library during that survey to give us not only area_use, but furniture location
	session_start();
    require_once('form_functions.php');
?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title> Library Query Report </title>
    <meta charset="utf-8" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <link rel="stylesheet" href="styles/layout.css" type="text/css" >
    <link rel="stylesheet" href="styles/format.css" type="text/css" >
</head>
<script type="text/javascript">

    var cur_selected_date;

    $(function(){
        $('#date-select').on("change", function(){
            var form_info = document.getElementById("choose_survey_form");
            cur_selected_date = form_info.elements["date-select"].value;

            //Get rid previous select options before repopulating 
            var select = document.getElementById('survey_id_select');
            var length = select.options.length;
            if(length > 1){
                for(i = 0; i < length; i++){
                    select.remove(1);
                }
            }
            $.ajax({
                url: 'phpcalls/get-survey-ids.php',
                type: 'get',
                data:{ 'selected_date': cur_selected_date },
                success: function(data){

                    console.log("got dates");
                    var json_object = JSON.parse(data);
                    var survey_select = document.getElementById('survey_id_select');

                    for(var i = 0; i < json_object.length; i++){
                        var obj = json_object[i];
                        surv_id = obj['survey_id'];
                        lay_id = obj['layout_id'];
                        var option = document.createElement('option');
                        option.value = surv_id;
                        option.innerHTML = "Survey: " + surv_id +" for Layout" + lay_id;
                        survey_select.appendChild(option);
                    }
                }
            });
        });
    });
</script>
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
		
		if (array_key_exists("survey_id", $_GET)){
			?>
			<script>
				var survey_id = <?= $_GET["survey_id"] ?>;
				
				$.ajax({
                url: 'phpcalls/reportAreaUse.php',
                type: 'get',
                data:{ 'survey_id': survey_id },
                success: function(data){
					var reportDiv = document.getElementById("reportDiv");
					reportDiv.innerHTML = data;
                    console.log("Printed Area Use.");
                },
				error: function(XMLHttpRequest, textStatus, errorThrown) { 
					console.log("Status: " + textStatus);
					console.log("Error: " + errorThrown); 
				}     
            });
			
			</script>
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
                    <p class="nav selected"><a href="query-report.php">Query Report</a></p>
                    <p class="nav"><a href="editor.php">Create A Layout</a></p>
                    <p class="nav"><a href="logout.php">Logout</a></p>
                </nav>
    </header>
    <main>
        <h2><?= $_SESSION["username"]?> what shall we query today? </h2>
        <form class="report-selector" id="choose_survey_form">
            <fieldset>
                <!--THIS IS A PLACEHOLDER! SELECT WILL BE POPULATED BY DATES FROM DB-->
                <select name="date" id="date-select">
                    <option value="0">Choose a Date</option>
                    <?php
                    get_dates_options();
                    ?>
                </select>
                <!--THIS IS A PLACEHOLDER! SELECT WILL BE POPULATED BY TIMES FROM DB-->
                <select name="survey_id" id="survey_id_select">
                    <option value="">Choose a Survey</option>
                </select>

                <input type="submit" name="submit-query" />
            </fieldset>
        </form>
                <?php
            }
        ?>
		<div id="reportDiv"></div>
    </main>
    <footer>
        <p>Designed by Web App team</p>
        <p> &copy; Humboldt State University</p>
    </footer>
</body>
</html>