$(document).ready(function(){
	var arguments = ['channel','get_channel.json','admin/channels','channel_type','null','channel_type','null']
	getJsonDatas.apply(null,arguments)
	$('.channel_id').live('change',function(){
		var arguments = ['channel','get_channel.json','admin/channels','channel_type','null','channel_type','null']
		getJsonDatas.apply(null,arguments)
	})
})
