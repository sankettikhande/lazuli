$( document ).ready(function() {
	$('#select_all_list').unbind().click(function(){
		if($(this).is(':checked')) {
			$('.box-title').addClass("active");
			$('.user_checkbox').prop("checked", true);
		} else {
			$('.box-title').removeClass("active");
			$('.user_checkbox').removeAttr('checked');
		}
	});

	$('.user_checkbox').unbind().click(function(){
		if($(this).is(':checked')) {
			$(this).parent().addClass("active");
		} else {
			$(this).parent().removeClass("active");
		}
	});

	/*********************************** block starts for fitering and searching videos *************************/
	/*spliting current url to get the controller name */
	var currnet_url = $(location).attr('href').split('/');
	var controller_name = currnet_url[currnet_url.length - 1];

	/* triiger search on change of filter select box value */
	$('#'+controller_name+'-filter-select').unbind().change(function(){
		get_search_params_and_call_search();
	});

	/* triiger search on key press of search input box */
	$('#'+controller_name+'-search-text').unbind().keyup(function(){
    get_search_params_and_call_search();
	});

	/* get values of search key & column name and fires ajax call to search records */
	function get_search_params_and_call_search(){
		var search_key = $('#'+controller_name+'-search-text').val(),
		    search_col = $('#'+controller_name+'-filter-select').val();
		if((search_key == '' && search_col == '') || (search_key.length > 2)){
			search_records(search_key, search_col);
		}
	}

	/* sends an ajax call to search records based on search key & cloumn */
	function search_records(search_key, search_col){
		$.ajax({
			type: "GET",
			url: "/"+controller_name+"/search",
			data: {sSearch: search_key, sSearch_1: search_col}
		});
	}
	/*********************************** block ends here for fitering and searching videos *************************/

	function clear_filters(){
		$("#histories-search-text").val("");
		$("#histories-filter-select").val("");
		get_search_params_and_call_search();
	}

	$("#filter_clear").unbind().click(function(){
		clear_filters();
	});
});