function add_bookmark(value){
    value = parseFloat(value / 100).toFixed(2).toString().replace(".",":");
    // var text = "<div class='row'><div class='col-xs-2'><input type='text' name='bookmark[]time' class='form-control' value='" + value +"'></div><div class='col-xs-2'><input type='text' name='bookmark[]title' class='form-control' placeholder='Title'></div><div class='col-xs-6'><textarea name='bookmark[]description' class='form-control' rows='1' placeholder='Describe this bookmark'></textarea></div><div class='col-xs-1'><button type='button' class='btn btn-trans' title='Remove' onclick='$(this).parent().parent().remove();javascript:void(0);'><i class='fa fa-minus-circle'></i></button></div></div><div class='seperator5'></div>"
    // $("#bookmark_form").append(text);
    var bookmark_form = $("#add_bookmark").click();

}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    alert(new_id);
    var regexp = new RegExp("new_" + association, "g")
    $(link).up().insert({
        before: content.replace(regexp, new_id)
    });
}
flowplayer("player", { src: "/assets/flowplayer-3.2.18.swf" , wmode:"transparent" }, {
    // a clip object
    clip: {
        // a clip event is defined inside clip object
        autoPlay: false,
        autoBuffering: true,
        onStart: function() {
            // alert("clip started");
        }
    },
    // player events are defined directly to "root" (not inside a clip)
    onBeforePause: function(event) {
        // console.log(flowplayer("player").getTime());
        add_bookmark(flowplayer("player").getTime());
    },
    onSeek: function(event){
        add_bookmark(flowplayer("player").getTime());
    }
});

$("#bookmark_button").click(function(){
    var btn = $(this)
    btn.button('loading')
    $("#bookmark_form").submit();
});



