$(document).ready(function(){
	var arguments = ['course','get_channel_info.json','admin/courses','topic_channel_id','t-channel','id','name']
	getJsonDatas.apply(null,arguments)
	$('.course_id').live('change',function(){
		var arguments = ['course','get_channel_info.json','admin/courses','topic_channel_id','t-channel','id','name']
		getJsonDatas.apply(null,arguments)
	})
})
