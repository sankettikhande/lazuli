$(window).load(function(){
  $(".formClass").validationEngine({
    validateNonVisibleFields: true,
    promptPosition : "bottomLeft",
    autoPositionUpdate: true,
    onValidationComplete: function(form, status) {
      $('.formError').css("left","15px")
      if(status == true){
        if ($('.require-one:checked').size() > 0)
          return true;
        else{
          alert("Please select atleast one subscriptions with price");          
          return false;
          }
        $(window).spin();
        return true
      }
    }
  });
});

$(document).ready(function(){
  $('.require-one').click(function(){
    if ($('.require-one:checked').size() > 0)
      return true;
    else{
      alert("Please select atleast one subscriptions with price");
      $(this).attr("checked", "checked");
      }
  });
})