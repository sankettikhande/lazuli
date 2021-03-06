$('.date-picker').datepicker({
   rtl: App.isRTL(),
   startDate: new Date(),
   format: 'yyyy-mm-dd',
   autoclose: true
 }).on('changeDate',function(ev){
	 $(this).find('.formError').remove();
	 var calculated_days = $(".subscription_id").find('option:selected').data('calculated_days')
	 var expiry_date = get_expiry_date(ev.date, calculated_days)
	 if (calculated_days != undefined)
	  $(".expiry_date").val(expiry_date);
});	

$(".subscription_id").on('change', function(){
  var subscription_date = $(".subscription_date").val();
  var calculated_days = $(this).find('option:selected').data('calculated_days')
  var event_date = jQuery.datepicker.parseDate("yy-mm-dd", subscription_date)
  if(subscription_date != ""){
    if ($(this).val() != ""){
    var expiry_date = get_expiry_date(event_date, calculated_days)
    $(".expiry_date").val(expiry_date);
    }
    else{
       $(".expiry_date").val("")
    }
  }
})

function get_expiry_date(subscription_date, calculated_days){
  var end_date = new Date(subscription_date.setDate(subscription_date.getDate() + (calculated_days - 1)));
  end_date = (end_date.getFullYear() + "-" + (end_date.getMonth() + 1) + "-" + end_date.getDate());
  return end_date;
}

$("#user_course_form").validationEngine({
  validateNonVisibleFields: true,
  promptPosition : "bottomLeft",
  onValidationComplete: function(form, status) {
    if(status == true){
      $(window).spin();
      return true
    }
  }
});

function add_valiadate_required() {
  $("#user_channel_subscription_subscription_id").addClass('validate[required]');
  $("#user_channel_subscription_subscription_date").addClass('validate[required]');
  $("#user_channel_subscription_expiry_date").addClass('validate[required]');
} 

function remove_validate_required() {
  $("#user_channel_subscription_subscription_id").removeClass('validate[required]');
  $("#user_channel_subscription_subscription_date").removeClass('validate[required]');
  $("#user_channel_subscription_expiry_date").removeClass('validate[required]');
}

if($('#user_channel_subscription_permission_create').is(":checked")){
    remove_validate_required()  
}

$('#user_channel_subscription_permission_create').change(function(){
  if($(this).is(":checked")) {
    remove_validate_required()
  }else{
    add_valiadate_required()
  }
})