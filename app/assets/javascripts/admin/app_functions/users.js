$(".user_action").click(function(){
  window.location = $("#user_mode:checked").data("redirect-url")
})