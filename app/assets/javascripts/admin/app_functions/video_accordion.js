jQuery(function ($) {
	if($('#seqNum1').val() == '')
		$('#seqNum1').val(1)
	$(document).on('nested:fieldAdded:videos', function(event) {
		$("#accordion1").find(".fields").each(function(index){
			$(this).find("#seqNum1").val(index + 1)
		})
	});
	$(document).on('nested:fieldRemoved:videos', function(event) {
		$(event.target).remove()
		$("#accordion1").find(".fields").each(function(index){
			$(this).find("#seqNum1").val(index + 1)
		})
	});
});