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