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
	$("#topics_tab").click(function(){
		load_topics();
	});
	$("#courses_tab").click(function(){
		load_courses();
	});
	$("#videos_tab").click(function(){
		load_videos();
	});
	load_videos();
});