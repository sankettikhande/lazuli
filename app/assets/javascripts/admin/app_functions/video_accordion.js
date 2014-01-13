jQuery(function ($) {
	if($('.sequence_number').val() == '')
		$('.sequence_number').val(1)
	$(document).on('nested:fieldAdded:videos', function(event) {
		$("#accordion1").find(".fields").each(function(index){
			$(this).find(".sequence_number").val(index + 1)
		})
	});
	$(document).on('nested:fieldRemoved:videos', function(event) {
		$(event.target).remove()
		$("#accordion1").find(".fields").each(function(index){
			$(this).find(".sequence_number").val(index + 1)
		})
	});
});