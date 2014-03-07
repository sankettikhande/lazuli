$( document ).ready(function() {
 	$('.typeahead').typeahead({
    source: function (query, process) {
      var search_key = $("#main_search").val();
      return $.get('/search/courses.json', { sSearch: search_key, sSearch_1: "name"}, function (data) {
          return process(data.courses);
      });
    }
  });
});