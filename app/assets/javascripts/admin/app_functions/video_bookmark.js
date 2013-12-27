function add_bookmark(value){
    var text = "<tr><td><input type='text' size='30' name='bookmark[]time' id='time' value='" + value +"' class='form-control'></td><td><input type='text' size='30' name='bookmark[]description' id='description' class='form-control'></td><td><a onclick='$(this).parent().parent().remove();javascript:void(0)' class='link'>Remove</a><td></tr>"
    $("#bookmark table").append(text);
}

flowplayer("player", "/assets/flowplayer-3.2.18.swf", {
    // a clip object
    clip: {
        // a clip event is defined inside clip object
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