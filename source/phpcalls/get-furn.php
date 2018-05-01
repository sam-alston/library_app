<?php
session_start();
require_once('./../config.php');

$layout_id =  $_REQUEST['layout_id'];
$data = array();

$dbh = new PDO($dbhost, $dbh_select_user, $dbh_select_pw);

$getfurn = $dbh->prepare('SELECT * FROM furniture WHERE layout_id = :set_layout');

/*statment for after layout is selected*/
$getfurn->bindParam(':set_layout', $layout_id, PDO::PARAM_INT);

$getfurn->execute();

foreach ($getfurn as $row) {
    //seperate query to get num seats based on furniture
    /*To be replaced with ajax call*/

    $numSeatsQuery = $dbh->prepare('SELECT number_of_seats
                                    FROM furniture_type
                                    WHERE furniture_type_id = :infurnid');

    $numSeatsQuery->bindParam(':infurnid', $row['furniture_type'], PDO::PARAM_INT);
    $numSeatsQuery->execute();

    $numSeatResult = $numSeatsQuery->fetch(PDO::FETCH_ASSOC);

    $keystring = $row['furniture_id'];
    $num_seats = $numSeatResult['number_of_seats'];
    $x = $row['x_location'];
    $y = $row['y_location'];
    $degree_offset = $row['degree_offset'];
    $furniture_type = $row['furniture_type'];
    $default_seat_type = $row['default_seat_type'];

    $array_item = array( $keystring => array( 'furniture_id' => $keystring,
											  'num_seats' => $num_seats,
											  ''))
    array_push($data, $array_item);
}

print json_encode($data);