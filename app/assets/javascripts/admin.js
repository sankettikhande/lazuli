// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require ./admin/jquery-ui-1.10.3.custom.min.js
//= require ./admin/bootstrap.min.js
//= require ./admin/bootstrap-datepicker.js

//= require ./admin/jquery.blockui.min.js
//= require ./admin/jquery.cookie.min.js
//= require ./admin/jquery.slimscroll.min.js
//= require ./admin/jquery.uniform.min.js
//= require ./admin/jquery-migrate-1.2.1.min.js

//= require ./admin/twitter-bootstrap-hover-dropdown.min.js
//= require ./admin/select2.min
//= require ./admin/index.js
//= require ./admin/tasks.js
//= require ./admin/app.js
//= require jquery_nested_form
//= require ./admin/form-components.js
//= require ./admin/bootstrap-fileupload.js
//= require ./admin/flowplayer-3.2.13.min.js
//= require ./admin/jquery.spin.js
//= require ./common.js
//= require ./application/html5shiv.js

$(".tooltip").tooltip()
$("a[rel=tooltip]").tooltip()

$( function() {
    $("button[data-href]").click( function() {
        location.href = $(this).attr("data-href");
    });
});

$(function() {
  var flashCallback,
    _this = this;
  flashCallback = function() {
    return $(".note").fadeOut();
  };
  $(".note").bind('click', function(ev) {
    return $(".note").fadeOut();
  });
  return setTimeout(flashCallback, 3000);
});

/* method to populate contents(chanels, users, course, topics & videos) in datatable */
function loadContents(tableId, url, aoColumns, optionNames, optionValues){
  var dtaTable = initDataTable(tableId, url, aoColumns);
  appendFilterList(optionNames, optionValues, tableId);
  triggerFnFilter(dtaTable, tableId, aoColumns);
  resetDataTable(tableId, dtaTable);
};

/* initializing dataTable for contents */
function initDataTable(tableId, url, aoColumns){
  return $(tableId).dataTable({
  "bProcessing": true,
  "bServerSide": true,
  "iDisplayLength": 15,
  "bLengthChange": false,
  "bAutoWidth": false,
  "sAjaxSource": url,
  "aoColumns": aoColumns,
  "aaSorting": [[ 1, "asc" ]] });
};

/* appends filter dropdown */
function appendFilterList(optionNames, optionValues, tableId){
  var dropdownHtml = '<label id="sort_filter">Filter By:</label><select class="filter_column_names" id="column_names"><option value="all">ALL</option>'
  $.each( optionValues, function( i, val ) {
    dropdownHtml = dropdownHtml + '<option value='+val+'>'+optionNames[i]+'</option>'
  });
  $(tableId+"_filter").append(dropdownHtml);
  clearFilterHtml = "<a class='clear_filter' style='margin-left: 15px;cursor: pointer;'><i class='fa fa-times-circle'></i> Clear Filter</a>"
  $(tableId+"_filter").append(clearFilterHtml);
};

/* calls fnFilter of dataTable */
function triggerFnFilter(dtaTable, tableId, aoColumns){
  $('select#column_names').on('change', function(e){
    if($(tableId+'_filter label input').val() != ''){
      dtaTable.fnFilter( $(this).val(), 1 );
    };
  });

  $(tableId+'_filter label input').on('keyup', function(e){
    /* TODO stop from being fired up fnfilter call twice on a single keyup event
       --need to disable datatable's default search somehow on keypup event */
    if($(tableId+'_filter label input').val() != ''){
      dtaTable.fnFilter($(tableId+'_filter select#column_names').val(), 1 );
    };
  });
};

/* removes filter and resets filter dropdown to default value*/
function resetDataTable(tableId, dtaTable){
  $('.clear_filter').on('click', function(e){
    var tab_link_id = tableId.split("_")[0] + "_tab"
    var contents = ["#videos_tab", "#topics_tab", "#courses_tab"]
    /* if block is for reseting contents(courses, videos & topics) dataTable */
    if($.inArray(tab_link_id, contents) > -1){
      $(tab_link_id).click();
    }else{  /* else block is for reseting users & channel dataTable */
      dtaTable.fnFilter('');
      $('select#column_names option[value="all"]').attr('selected', 'selected');
    }
  });
};

