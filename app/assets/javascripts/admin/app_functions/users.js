$(".user_action").click(function(){
  window.location = $("#user_mode:checked").data("redirect-url")
})
$(document).ready(function(){
	$("#user_form").validationEngine({
		promptPosition : "bottomLeft",
		autoPositionUpdate: true,
		onValidationComplete: function(form, status) {
			if(status == true){
				$(window).spin();
				return true
			}
		}
	})
});

$('input[type="checkbox"]').uniform();

$("#multiple_user_form").validationEngine({
	promptPosition : "bottomLeft",
	autoPositionUpdate: true,
	onValidationComplete: function(form, status) {
		if(status == true){
			$(window).spin();
			return true
		}
	}
});