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

  $("#remove-favourite").click(function (){
    $('#add-favourite').show();
    $('#remove-favourite').hide();
  });

  $("#add-favourite").click(function (){
    $('#add-favourite').hide();
    $('#remove-favourite').show();
  });
});

