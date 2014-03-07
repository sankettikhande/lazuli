var countChecked = function() {
var n = $( ".as_lead input:checked").length;
if (n >= 2){
  alert("You can add only one Lead Trainer");
    $(this).attr('checked',false); 
  }
};
countChecked();
$( "input[type=checkbox]").on( "click", countChecked );

