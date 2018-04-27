<?php
//destroys session to logout
 session_start();
 session_destroy();
 header("Location:index.php");
?>