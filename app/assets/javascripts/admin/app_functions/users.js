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

function user_info_disabled(){
	$("#user_actual_name").attr('disabled', true)
	$("#user_name").attr('disabled', true)
	$("#user_email").attr('disabled', true)
	$("#user_password").attr('disabled', true)
	$("#user_phone_number").attr('disabled', true)
	$("#user_company_name").attr('disabled', true)
	$("#user_address").attr('disabled', true)
}

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