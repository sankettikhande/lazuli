$('#fgt_password').click(function(){
  $('.login_box').hide();
  $('.forget_password').show();
  return false
})
$('#comfirm_instruction').click(function(){
  $('.forget_password').hide();
  $('.confirm_instructions').show();
  return false
})
$('.close').click(function(){
  $('.forget_password').hide();
  $('.confirm_instructions').hide();
  $('.login_box').show();
})

$('#user-actual-name').change(function(){
  $('#user-name').val($(this).val())
})