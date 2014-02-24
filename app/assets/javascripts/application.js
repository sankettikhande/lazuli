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
//= require ./application/bootstrap.min.js
//= require ./application/excanvas.min.js
//= require ./application/html5shiv.js
//= require ./application/offcanvas.js
//= require ./application/respond.min.js
//= require_tree ./application/.
//= require ./common.js
//= require ./application/jquery.slimscroll.min.js
//= require jquery-star-rating

$( function() {
    $("button[data-href]").click( function() {
        location.href = $(this).attr("data-href");
    });
});

$( document ).ready(function() {
  $('body').on('click', '.dropdown-menu.hold-on-click', function (e) {
    e.stopPropagation();
  });
});
