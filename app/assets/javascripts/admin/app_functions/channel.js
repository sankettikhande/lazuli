$(document).ready(function(){
	videoAccordionForm();
	$('.add_nested_fields').live('click',function(){
		videoAccordionForm();
	})
})

function videoAccordionForm(){
	App.initUniform();
	$(".video_tag_list").select2({
      tags: []
  });
}

$('#user_search_channel').change(function(){
	if($(this).val() != ''){
  	$('#s2id_user_search_channel').removeClass('validate[required]');
  	}
});

// for edit channel
$('document').ready(function(){
	if ($('#user_search_channel').val() != ''){
		$.each($(".select2"), function (i, n) {
			$(n).next().show().fadeTo(0, 0).height("0px").css("left", "auto");
			$(n).prepend($(n).next());
			$(n).delay(500).queue(function () {
				$(this).removeClass("validate[required]");
				$(this).dequeue();
			});
		});
	}
})