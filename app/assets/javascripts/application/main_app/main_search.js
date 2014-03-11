$( document ).ready(function() {
 	$('.typeahead').typeahead({
    source: function (query, process) {
      var search_key = $("#main_search").val();
      return $.get('/search/suggestions.json', { sSearch: search_key, sSearch_1: "title"}, function (data) {
          return process(data.results);
      });
    }
  });
});