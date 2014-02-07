$( document ).ready(function() {
  $('.parent-course-menu').slimScroll({
    height: '400px',
    disableFadeOut: true
  });
  $('.parent-course-menu li').click(function(e){
    $('li.active').removeClass('active');
    $(this).addClass('active');
  });
  $("#watch_lator").click(function () {
    $("#watch_list_btn").data("watch", true);
    $(this).hide();
    $("#remove_watch_lator").show();
  });

  $("#remove_watch_lator").click(function (){
    $("#watch_list_btn").data("watch", false);
    $(this).hide();
    $("#watch_lator").show();
  });

  if($("#watch_list_btn").data("watch") == true){
    $('#watch_lator').hide();
  }else{
    $('#remove_watch_lator').hide();
  }

  $(".subscription_now").click(function(){
    $('.content1').hide();
    $('.content2').show();
    return false;
  });

  $("#subscription_confirm .cancel_button").click(function(){
    $('.content2').hide();
    $('.content1').show();
  });

  var player = $('#player_1')[0];
  video_id = $("#watch_list_btn").data("video_id");
  course_id = $("#watch_list_btn").data("course_id");
  watch_list_url = "/remove/watchlist/video/" + video_id + "/" + course_id + ".js"
  history_list_url =  "/histories/"+ video_id + "/save_history.js"

  $f(player).addEvent('ready', ready);

  function ready(player_id) {
    var froogaloop = $f(player_id);

    function onPlay(watch_list_url, history_list_url) {
      froogaloop.addEvent('play', function(data) {
        watch_list(watch_list_url)
        history(history_list_url)
      });
    }

    function watch_list(url){
      if($("#watch_list_btn").data("watch") == true){
        $.ajax({
          url: url
        });
        $("#watch_list_btn").data("watch", false);
        $('#remove_watch_lator').hide();
        $("#watch_lator").show();
      }
    }

    function history(url){
      if($("#history_btn").data("watch") == false){
        $.ajax({
          url: url
        });
        $("#history_btn").data("watch", true);
      }
    }
    $("#history_btn").data("video_id")
    onPlay(watch_list_url, history_list_url);
  }
});

