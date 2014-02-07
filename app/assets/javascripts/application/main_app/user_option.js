$( document ).ready(function() {
	$('#select_all_list').unbind().click(function(){
		if($(this).is(':checked')) {
			$('.box-title').addClass("active");
			$('.user_checkbox').prop("checked", true);
		} else {
			$('.box-title').removeClass("active");
			$('.user_checkbox').removeAttr('checked');
		}
	});

	$('.user_checkbox').unbind().click(function(){
		if($(this).is(':checked')) {
			$(this).parent().addClass("active");
		} else {
			$(this).parent().removeClass("active");
		}
	});
});