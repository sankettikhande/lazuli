$( document ).ready(function() {
	/* triiger search on key press of search input box */
	$("#search-courses").unbind().keyup(function(){
		var search_key = $(this).val();
		var channel_id =$('#channel_id').val();
		if(search_key.length == 0 || search_key.length > 2){
			get_search(search_key, channel_id, "courses");
		}
	});

	/* get values of search key & column name and fires ajax call to search records */
	function get_search(search_key, channel_id, controller_name){
		$.ajax({
			type: "GET",
			url: "/"+controller_name+"/search",
			data: {channel_id: channel_id, sSearch: search_key, sSearch_1: "title"}
		});
	}
});
