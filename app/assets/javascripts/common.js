//= require ./admin/jquery.validationEngine.js
//= require ./admin/jquery.validationEngine-en.js
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