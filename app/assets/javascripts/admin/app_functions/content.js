$(document).ready(function(){
	function load_topics(){
		$.ajax({
	    type: "GET",
	    url: "/admin/contents/get_topics"
	  }).success(
	  $("#list_set_1").text("Topics"));
	}
	function load_videos(){
		$.ajax({
	    type: "GET",
	    url: "/admin/contents/get_videos"
	  }).success(
	  $("#list_set_1").text("Video"));
	}
	function load_courses(){
		$.ajax({
	    type: "GET",
	    url: "/admin/contents/get_courses"
	  }).success(
	  $("#list_set_1").text("Courses"));
	}

	function load_content(divid){
    if(divid == "topics"){
			load_topics();
    }else if (divid == "videos"){
    	load_videos();
    }else{
    	load_courses();
    }
	}

	$('.nav-tabs').bind('click', function (e) {
    var now_tab = e.target // activated tab
    // get the div's id
    var divid = $(now_tab).attr('href').substr(1);
    load_content(divid)
  });

	url = window.location.href
	url_split = url.split("#")
	load_content(url_split[1]);

	if($(".breadcrumb").text()=='Contents'){
		$("#list_set_1").text("Video");
	}

	var selected_fields = window.location.href.split("#").pop();
	load_content(selected_fields);

});