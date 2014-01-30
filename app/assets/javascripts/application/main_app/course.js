$( document ).ready(function() {
   $('.parent-course-menu').slimScroll({
      height: '400px',
      disableFadeOut: true
    });
    $('.parent-course-menu li').click(function(e){
      $('li.active').removeClass('active');
      $(this).addClass('active');
    });

	$('#btn-subscribe').on('click', function(){
		if (!$('.radio-btn-course-subscription').val()){
			alert('Please select a subscription');
			return false;
		}
	});
});