jQuery(function ($) {
	if($('.sequence_number').val() == '')
		$('.sequence_number').val(1)
	$(document).on('nested:fieldAdded:videos', function(event) {
		var courses_id = $("#topic_course_id").val()
		if(courses_id != ''){
			$.ajax({
				url: "/admin/courses/"+courses_id+"/course_subscription_types.js",
				data: {topic_course: true}
			});
		}
		$("#accordion1").find(".fields").each(function(index){
			$(this).find(".sequence_number").val(index + 1)
		})
	});
	$(document).on('nested:fieldRemoved:videos', function(event) {
		$(event.target).find("[class*='validate[']").remove()
		$("#accordion1").find(".fields").each(function(index){
			$(this).find(".sequence_number").val(index + 1)
		})
	});
});