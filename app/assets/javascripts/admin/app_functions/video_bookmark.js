function add_bookmark(value){
    var text = "<tr><td><input type='text' name='bookmark[]time' value='" + value +"' class='form-control time'></td><td><input type='text' name='bookmark[]description' class='form-control description'></td><td><a href='#' class='btn btn-trans' rel='tooltip' title='Delete' onclick='$(this).parent().parent().remove();javascript:void(0)'><i class='fa fa-ban'></i></a><td></tr>"
    $("#bookmark table").append(text);
}

flowplayer("player", "/assets/flowplayer-3.2.18.swf", {
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
    $("#bookmark_form").submit();
});