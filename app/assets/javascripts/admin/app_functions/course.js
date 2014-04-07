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

 	$('#channel_id').change(function(){
 		if($(this).val() != ''){
	  	$('#s2id_channel_id').removeClass('validate[required]');
	  }else{
	  	$('#s2id_channel_id').addClass('validate[required]');
	  }
	});

	if ($('#channel_id').val() != ''){
		$.each($(".select2me"), function (i, n) {
			$(n).next().show().fadeTo(0, 0).height("0px").css("left", "auto");
			$(n).prepend($(n).next());
			$(n).delay(500).queue(function () {
				$(this).removeClass("validate[required]");
				$(this).dequeue();
			});
		});
	}
});
