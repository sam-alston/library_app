function build_markers(layout_id){
	$.ajax({
        url: 'phpcalls/get-furn.php',
        type: 'post',
        data:{ 'layout_id': layout_id },
        success: function(data){
            /*need to replace with ajax call getting actual layout id's*/

            console.log("got number of layouts");
            var json_object = JSON.parse(data);

        }
    });

}