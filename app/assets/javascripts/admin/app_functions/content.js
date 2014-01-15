$(document).ready(function(){
	function load_topics(){
		$.ajax({
	    type: "GET",
	    url: "/admin/contents/get_topics"
	  });
	}
	function load_videos(){
		$.ajax({
	    type: "GET",
	    url: "/admin/contents/get_videos"
	  });
	}
	function load_courses(){
		$.ajax({
	    type: "GET",
	    url: "/admin/contents/get_courses"
	  });
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
});