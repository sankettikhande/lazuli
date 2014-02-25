$('.password_change').click(function(){
  $('.user_info').hide()
  $('.change_pasword').show()
  $('.my_account').show()
  return false;
})

$('.my_account').click(function(){
  $('.user_info').show()
  $('.change_pasword').hide() 
  return false;
})

$('.default').click(function(){
  $('.change_pasword').hide()
  $('.user_info').show()
  $('#password_errors').hide()
  $('#errors').hide()
})