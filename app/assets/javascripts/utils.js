function getJsonDatas( var1,json_file,controller,ss1,ss2,v1,v2){
	var value = $("."+var1 +"_id :selected").val();
	if(value == undefined || value == ""){
    if($("#"+ss1).val()==""){
			$("#"+ss1).val("");
		}
		if($("#"+ss2).val()==""){
			$("#"+ss2).val("");}
	}else{
		$.ajax({
		    url: "/"+ controller +"/"+ value +"/"+ json_file ,
		    success: function(responseData) {
					var item = responseData.data
					$("#"+ss1).val(item[v1])
					$("#"+ss2).val(item[v2])
		    }
		})
	};
};