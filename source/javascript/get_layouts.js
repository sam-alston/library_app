//Constantly Checking the selected floor, to be used to implement building the layout select dynamically instead of a post
//Not complete
$(function(){
    $('#floor-select').change( function(){
        var form_info = document.getElementById("floor-select");
        var choose_floor = form_info.value;
        $.ajax({
            url: 'phpcalls/floor-select.php',
            type: 'get',
            data:{
                'floor_ID': choose_floor
            },
            success: function(data){
                /*Not complete yet, needs to return information as a JSON array*/
                console.log("success, ajax ran got session variable: ");
            }
        });
    });
});
