$(window).load(function(){
  $(".formClass").validationEngine({
    validateNonVisibleFields: true,
    promptPosition : "bottomLeft",
    autoPositionUpdate: true,
    onValidationComplete: function(form, status) {
      $('.formError').css("left","15px")
      if(status == true){
        $(window).spin();
        return true
      }
    }
  });
});