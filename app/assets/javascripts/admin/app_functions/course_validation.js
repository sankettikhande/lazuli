$(document).ready(function(){
  $(".course_form").validationEngine({
    validateNonVisibleFields: true,
    promptPosition : "bottomLeft",
    autoPositionUpdate: true,
    onValidationComplete: function(form, status) {
      $('.formError').css("left","15px")
      if(status == true){
        if ($('.require-one:checked').size() < 1) {
          alert("Please select atleast one subscriptions with price");          
          return false;
          }
        $(window).spin();
        return true
      }
    }
  });


  $('.require-one').click(function(){
    if ($('.require-one:checked').size() > 0)
      return true;
    else{
      alert("Please select atleast one subscriptions with price");
      $(this).attr("checked", "checked");
      }
  });
})