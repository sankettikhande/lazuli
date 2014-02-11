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
  $("#list_set_1").click(function(){
  	var selected_fields = $("#list_set_1").text()
  	window.location.href = '/admin/contents' + "#"+selected_fields.toLowerCase();
  }); 

  $('#topic_course_id').change(function(){
    var val = $("option:selected",this).val();
    $.ajax({
      url: "/admin/courses/"+val+"/course_subscription_types.js",
      data: {topic_course: true}
    });
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
