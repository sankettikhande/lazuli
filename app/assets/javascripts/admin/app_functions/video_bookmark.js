jQuery(function ($) {
    function secondstotime(secs)
    {
        var t = new Date(1970,0,1);
        t.setSeconds(secs);
        var s = t.toTimeString().substr(0,8);
        if(secs > 86399)
            s = Math.floor((t - Date.parse("1/1/70")) / 3600000) + s.substr(2);
        return s;
    }

    function add_bookmark(value){
        if(Math.floor(value) != 0) {
            value = secondstotime(Math.floor(value));
            var new_id  = new Date().getTime();
            var text = "<div class='row fields'><div class='seperator5'></div><div class='col-xs-2'><input class='form-control' id='video_bookmarks_attributes_new_bookmarks_time' name='video[bookmarks_attributes][" + new_id + "][time]' size='30' type='hidden' value="+ value +" /><input class='form-control' name='video[bookmarks_attributes][" + new_id + "][time]' size='30' type='text' value="+ value +" disabled='disabled' /></div><div class='col-xs-2'><input class='form-control' placeholder='Title' id='video_bookmarks_attributes_new_bookmarks_title' name='video[bookmarks_attributes][" + new_id + "][title]' size='30' type='text' /></div><div class='col-xs-6'><textarea class='form-control' cols='40' id='video_bookmarks_attributes_new_bookmarks_description' placeholder='Describe this bookmark' name='video[bookmarks_attributes][" + new_id + "][description]' rows='1'></textarea></div><div class='col-xs-1'><input type='hidden' value='false' name='video[bookmarks_attributes][" + new_id + "][_destroy]' id='video_bookmarks_attributes_" + new_id + "__destroy'><a href='javascript:void(0)' class='remove_nested_fields' data-association='bookmarks' rel='tooltip' title='Remove bookmark' ><button class='btn btn-trans'><i class='fa fa-minus-circle'></i></button></a></div></div>"
            $("#bookmark_form").append(text);
        }
    }

    flowplayer("player", { src: "/assets/flowplayer-3.2.18.swf" , wmode:"transparent" }, {
        // a clip object
        clip: {
            // a clip event is defined inside clip object
            autoPlay: false,
            autoBuffering: true,
            provider: 'lighttpd',
            onSeek: function(event){
                add_bookmark(flowplayer("player").getTime());
            }
        },
        plugins: {
            lighttpd: {
                url: "/assets/flowplayer.pseudostreaming-3.2.13.swf"
            }
        },
        // player events are defined directly to "root" (not inside a clip)
        // onBeforePause: function(event) {
        //     // console.log(flowplayer("player").getTime());
        //     add_bookmark(flowplayer("player").getTime());
        // },
    });

    $("#bookmark_button").unbind().click(function(){
        var btn = $(this)
        btn.button('loading')
        $("#bookmark_form").submit();
    });

    $(".bookmark_model_close").unbind().click(function(){
        window.location.reload();
    });
});



