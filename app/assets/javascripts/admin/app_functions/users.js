function user_action(){
  if ($("input[type='radio'][name='user_mode']:checked").val() == 'single-user'){
    window.location.href = "/admin/users/new"
  } else {
    window.location.href = "/admin/users/new_bulk"
  }
}