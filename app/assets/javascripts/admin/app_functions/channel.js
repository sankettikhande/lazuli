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