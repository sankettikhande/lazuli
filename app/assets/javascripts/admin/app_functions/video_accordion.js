var courses_id = $("#topic_course_id").val()
trial_subscription_check(courses_id)

function trial_subscription_check(courses_id){
	if(courses_id != ''){
		$.ajax({
			url: "/admin/courses/"+courses_id+"/course_subscription_types.js",
			data: {topic_course: true}
		});
	}
}

jQuery(function ($) {
	if($('.sequence_number').val() == '')
		$('.sequence_number').val(1)
	$(document).on('nested:fieldAdded:videos', function(event) {
		var courses_id = $("#topic_course_id").val()
		trial_subscription_check(courses_id)
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