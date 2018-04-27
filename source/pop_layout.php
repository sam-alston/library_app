<?php
//is this still being used?
	public function getLayouts(){

		foreach($dbh->query('SELECT * FROM layout WHERE floor = '.$_SESSION['cur_floor']) as $row){
            ?>
            <option value="<?= $row['layout_id'] ?>">Layout <?= $i ?> for Layout ID: <?= $row['layout_id'] ?> </option>
            <?php
        }
}
?>