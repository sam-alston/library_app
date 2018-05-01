//Constantly Checking the selected floor, to be used to implement building the layout select dynamically instead of a post

$(function(){
    $('#floor-select').on("change", function(){
        var form_info = document.getElementById("lay-select");
        floor_ID = form_info.elements["floor-select"].value;

        //Get rid previous select options before repopulating 
        var select = document.getElementById('current_layouts');
        var length = select.options.length;
        if(length > 1){
            for(i = 0; i < length; i++){
                select.remove(1);
            }
        }
        $.ajax({
            url: 'phpcalls/floor-select.php',
            type: 'get',
            data:{ 'floor_ID': floor_ID },
            success: function(data){
                /*need to replace with ajax call getting actual layout id's*/

                console.log("got number of layouts");
                var json_object = JSON.parse(data);
                var lay_select = document.getElementById('current_layouts');

                for(var i = 0; i < json_object.length; i++){
                    var obj = json_object[i];
                    lay_id = obj['layout_id'];
                    var option = document.createElement('option');
                    option.value = lay_id;
                    option.innerHTML = "Layout " + lay_id +" for Floor";
                    lay_select.appendChild(option);
                }
            }
        });
    });
});

$(function(){
    $('#current_layouts').on("change", function(){
        var form_info = document.getElementById("lay-select");
        layout = form_info.elements["layout-select"].value;
    });
});