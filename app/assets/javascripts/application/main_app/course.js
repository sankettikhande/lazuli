$( document ).ready(function() {
   $('.parent-course-menu').slimScroll({
      height: '400px',
      disableFadeOut: true
    });
    $('.parent-course-menu li').click(function(e){
      $('li.active').removeClass('active');
      $(this).addClass('active');
    });
});