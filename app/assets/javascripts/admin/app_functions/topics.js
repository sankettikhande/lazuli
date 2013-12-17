	$(document).ready(function(){
		var arguments = ['course','get_channel_info.json','admin/courses','topic_channel_id','t-channel','id','name']
		getJsonDatas.apply(null,arguments)
		$('.course_id').live('change',function(){
			var arguments = ['course','get_channel_info.json','admin/courses','topic_channel_id','t-channel','id','name']
			getJsonDatas.apply(null,arguments)
		})
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