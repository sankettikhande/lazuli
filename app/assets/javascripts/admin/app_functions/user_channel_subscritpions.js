$('body').on('focus',".date-picker", function(){
    $(this).datepicker();
  });
  $(document).ready(function(){

    $('.channels_id').change(function(){
      var subscription_id = $(this).closest(".form-group").next().next().find(".subscriptions_id").attr('id');
      var course_id = $(this).closest(".form-group").next().find(".courses_id").attr('id');
      var val = $("option:selected",this).val();
      $.ajax({
              url: "/admin/users/course_subscription_types.js",
              data: {id: val, subscription: subscription_id, course: course_id}       
            });
     });

    $('.date-picker').datepicker({
     rtl: App.isRTL(),
           autoclose: true
         }).on('changeDate',function(ev){
         var date_id = $(this).closest(".parent_div").find(".expiry_date").attr('id');
         var subscription_id = $(this).closest(".form-group").prev().find(".subscriptions_id").attr('id');
         var calculated_days = $('#'+subscription_id).find('option:selected').data('calculated_days');
         var expiry_date = get_expiry_date(ev.date, calculated_days)
         $("#"+date_id).val(expiry_date);
        });

        function get_expiry_date(subscription_date, calculated_days){
          var end_date = new Date(subscription_date.setDate(subscription_date.getDate() + calculated_days));
          end_date = (end_date.getDate() + "-" + (end_date.getMonth() + 1) + "-" + end_date.getFullYear());
          return end_date;
        }

  })