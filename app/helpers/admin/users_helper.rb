module Admin::UsersHelper
  def user_actions(user)
  	if user.confirmed?
  		"<a href='/admin/users/#{user.id}/edit' rel='tooltip' title='Edit User' data-no-turbolink='true' class='btn-trans'><i class='fa fa-edit'></i></a><a href='/admin/users/#{user.id}' data-method='delete' data-confirm='Are you sure you want to delete?' rel='tooltip' title='Delete User' class='btn-trans'><i class='fa fa-ban'></i></a>".html_safe
  	else
  		"<a href='#' rel='tooltip' title='Edit User' data-no-turbolink='true' class='btn-trans'><i class='fa fa-edit'></i></a><a href='/admin/users/#{user.id}' data-method='delete' data-confirm='Are you sure you want to delete?' rel='tooltip' title='Delete User' class='btn-trans'><i class='fa fa-ban'></i></a>".html_safe
  	end
  end
end
