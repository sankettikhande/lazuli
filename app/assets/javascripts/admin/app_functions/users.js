$(".user_action").click(function(){
  window.location = $("#user_mode:checked").data("redirect-url")
})

$("#user_form").validationEngine({
	promptPosition : "bottomLeft",
	autoPositionUpdate: true
});