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
	$('.channels_id').change(function(){
    var course_id = $(this).closest(".form-group").next().find(".courses_id").attr('id');
    var val = $("option:selected",this).val();
    $.ajax({
            url: "/admin/channels/"+val+"/channel_courses.js",
            data: {id: val, course_id: course_id}
          });
    });
})

function videoAccordionForm(){
	App.initUniform();
	$(".video_tag_list").select2({
      tags: []
  });
}
