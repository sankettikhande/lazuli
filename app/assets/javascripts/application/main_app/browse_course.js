$( document ).ready(function() {
	/* triiger search on key press of search input box */
	$("#search_browse_courses").unbind().keyup(function(){
		var search_key = $(this).val();
		if(search_key.length == 0 || search_key.length > 2){
			get_search(search_key, "channels");
		}
	});

	/* get values of search key & column name and fires ajax call to search records */
	function get_search(search_key, controller_name){
		$.ajax({
			type: "GET",
			url: "/search/" + controller_name,
			data: {sSearch: search_key, iDisplayLength: 15}
		});
	}
});
