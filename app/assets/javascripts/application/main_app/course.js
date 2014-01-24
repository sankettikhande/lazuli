$( document ).ready(function() {
   $('body').on('click', '.dropdown-menu.hold-on-click', function (e) {
           e.stopPropagation();
       });
   $('.parent-course-menu').slimScroll({
      height: '400px',
      disableFadeOut: true
    });
    $('.parent-course-menu li').click(function(e){
      $('li.active').removeClass('active');
      $(this).addClass('active');
    });
});