$('body').on('focus',".date-picker", function(){
    $(this).datepicker();
});

  $(document).ready(function(){

    $('.channels_id').change(function(){
      var course_id = $(this).closest(".fields").find(".courses_id").attr('id');
      var val = $("option:selected",this).val();
      $.ajax({
              url: "/admin/channels/"+val+"/channel_courses.js",
              data: {id: val, course_id: course_id}
            });
     });

    $('.date-picker').datepicker({
           rtl: App.isRTL(),
           startDate: new Date(),
           autoclose: true
         }).on('changeDate',function(ev){
         $(this).find('.formError').remove(); 
         var date_id = $(this).closest(".fields").find(".expiry_date").attr('id');
         var subscription_id = $(this).closest(".fields").find(".subscriptions_id").attr('id');
         var calculated_days = $('#'+subscription_id).find('option:selected').data('calculated_days');
         var expiry_date = get_expiry_date(ev.date, calculated_days)
         if (calculated_days != undefined)
          $("#"+date_id).val(expiry_date);
        });

        function get_expiry_date(subscription_date, calculated_days){
          var end_date = new Date(subscription_date.setDate(subscription_date.getDate() + (calculated_days - 1)));
          end_date = (end_date.getDate() + "-" + (end_date.getMonth() + 1) + "-" + end_date.getFullYear());
          return end_date;
        }

    $('.courses_id').change(function(){
      var subscription_id = $(this).closest(".fields").find(".subscriptions_id").attr('id');
      var permission_id = $(this).closest(".fields").find('.permissions').attr('id');
      var val = $("option:selected",this).val();
      $.ajax({
              url: "/admin/courses/"+val+"/course_subscription_types.js",
              data: {id: val, subscription_id: subscription_id, permission_id: permission_id}
            });
    })

    $('.subscriptions_id').on('change', function(){
      var subscription_date_id = $(this).closest(".fields").find(".subscription_date").attr('id')
      var subscription_id = $(this).attr('id')
      var calculated_days = $('#'+subscription_id).find('option:selected').data('calculated_days');
      var date_id = $(this).closest(".fields").find(".expiry_date").attr('id');
      var subscription_date_select = $('#'+subscription_date_id).val();
      var event_date = jQuery.datepicker.parseDate("dd-mm-yy", subscription_date_select)
      if(subscription_date_select != ""){
        if ($(this).val() != ""){
        var expiry_date = get_expiry_date(event_date, calculated_days)
        $("#"+date_id).val(expiry_date);
        }
        else{
           $("#"+date_id).val("")
        }
      }
    })

  })

$('input[type="checkbox"]').uniform();

jQuery(function ($) {
  $(document).on('nested:fieldRemoved:user_channel_subscriptions', function(event) {
    $(event.target).remove()
  });
});