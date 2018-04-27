<?php
//this is the file that will make login work on a local host with default user root, with no password
//this file should NEVER be pushed. These can be made by individual users to access their own localhost.
	$dbhost = 'mysql:host=localhost; dbname=hsu_library';
	$dbh_select_user = "root";
	$dbh_select_pw = "";
	$dbh_insert_user = "root";
	$dbh_insert_pw = "";
?>