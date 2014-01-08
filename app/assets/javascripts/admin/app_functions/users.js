$(".user_action").click(function(){
  window.location = $("#user_mode:checked").data("redirect-url")
})

$("#user_form").validationEngine({
	promptPosition : "bottomLeft",
	autoPositionUpdate: true
});

$('input[type="checkbox"]').uniform();

$(document).ready(function() { 
	$("#multiple_user_form").validationEngine({
		promptPosition : "bottomLeft",
		autoPositionUpdate: true
	});
 
  $('#multiple_user_form').ajaxForm(); 
});