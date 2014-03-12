$('input[type="checkbox"]').uniform();

var countChecked = function() {
var n = $( ".as_lead input:checked").length;
if (n >= 2){
  alert("You can add only one Lead Trainer");
    $(this).closest('.checked').removeClass('checked')
    return false;
  }
};
countChecked();
$( "input[type=checkbox]").on( "click", countChecked );

