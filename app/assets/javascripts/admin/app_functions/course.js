$(document).ready(function(){
	var arguments = ['channel','get_channel.json','admin/channels','channel_type','null','channel_type','null']
	getJsonDatas.apply(null,arguments)
	$('.channel_id').live('change',function(){
		var arguments = ['channel','get_channel.json','admin/channels','channel_type','null','channel_type','null']
		getJsonDatas.apply(null,arguments)
	});

  $("#list_set_1").click(function(){
		var selected_fields = $("#list_set_1").text()
		window.location.href = '/admin/contents' + "#" +selected_fields.toLowerCase();
  });

});
