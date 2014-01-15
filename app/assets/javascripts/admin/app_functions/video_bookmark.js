jQuery(function ($) {
    function add_bookmark(value){
        value = parseFloat(value / 100).toFixed(2).toString().replace(".",":");
        var new_id  = new Date().getTime();
        var text = "<div class='row'><div class='col-xs-2'><input class='form-control' id='video_bookmarks_attributes_new_bookmarks_time' name='video[bookmarks_attributes][" + new_id + "][time]' size='30' type='text' value="+ value +" /></div><div class='col-xs-2'><input class='form-control' placeholder='Title' id='video_bookmarks_attributes_new_bookmarks_title' name='video[bookmarks_attributes][" + new_id + "][title]' size='30' type='text' /></div><div class='col-xs-6'><textarea class='form-control' cols='40' id='video_bookmarks_attributes_new_bookmarks_description' placeholder='Describe this bookmark' name='video[bookmarks_attributes][" + new_id + "][description]' rows='1'></textarea></div><div class='col-xs-1'><input type='hidden' value='false' name='video[bookmarks_attributes][" + new_id + "][_destroy]' id='video_bookmarks_attributes_" + new_id + "__destroy'><a href='javascript:void(0)' class='remove_nested_fields' data-association='bookmarks' rel='tooltip' title='Remove bookmark'><button class='btn btn-trans'><i class='fa fa-minus-circle'></i></button></a></div></div><div class='seperator5'></div>"
        $("#bookmark_form").append(text);
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

    $("#bookmark_button").unbind().click(function(){
        var btn = $(this)
        btn.button('loading')
        $("#bookmark_form").submit();
    });
});



