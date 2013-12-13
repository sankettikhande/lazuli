$(document).ready(function(){
		getChannelNames();
	$('.course_id').live('change',function(){
		getChannelNames();
	})})
  function getChannelNames(){
		var course = $(".course_id :selected").val();
		if(course == undefined || course == ""){
			$("#topic_channel_id").val("");
			$("#t-channel").val("")
		}else{
			$.ajax({
			    url: "/admin/courses/"+ course +"/get_channel_info.json",
			    success: function(responseData) {
						var item = responseData.data.channel
						$("#topic_channel_id").val(item.id)
						$("#t-channel").val(item.name)
			    }
			})
		}
  }