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
//= require ./admin/table-advanced.js
//= require ./admin/twitter-bootstrap-hover-dropdown.min.js
//= require ./admin/select2.min
//= require ./admin/index.js
//= require ./admin/tasks.js
//= require ./admin/app.js
//= require jquery_nested_form
//= require ./admin/form-components.js
//= require ./admin/bootstrap-fileupload.js
//= require ./admin/flowplayer-3.2.13.min.js

$(".tooltip").tooltip()
$("a[rel=tooltip]").tooltip()

$( function() {
    $("button[data-href]").click( function() {
        location.href = $(this).attr("data-href");
    });
});
