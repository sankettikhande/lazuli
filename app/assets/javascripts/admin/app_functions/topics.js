$(document).ready(function(){
	var arguments = ['course','get_channel_info.json','admin/courses','topic_channel_id','t-channel','id','name']
	getJsonDatas.apply(null,arguments)
	$('.course_id').live('change',function(){
		var arguments = ['course','get_channel_info.json','admin/courses','topic_channel_id','t-channel','id','name']
		getJsonDatas.apply(null,arguments)
	})
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

$("#uniform-topic_is_bookmark_video_true :checked").live('change',function(){
		var number = $(".fields").length
		if(number != 1){
			$(".fields").slice(1-number).remove();
		}
		$("#video_link").hide();
		$("#bookmark_link").show();
	})
$("#uniform-topic_is_bookmark_video_false :checked").live('change',function(){
		$("#video_link").show();
		$("#bookmark_link").hide();
	})