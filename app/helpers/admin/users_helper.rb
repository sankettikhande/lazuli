module Admin::UsersHelper
  def user_actions(user)
  	if user.confirmed?
  		link_to(link_raw_field('fa fa-edit'), edit_admin_user_path(user), :rel=>'tooltip', :title => 'Edit User', :class=>'btn-trans', :data =>{'no-turbolink'=>'true'}) << link_to(link_raw_field('fa fa-ban'), admin_user_path(user), :rel=>'tooltip', :title => 'Delete User', :class=>'btn-trans', :data =>{'no-turbolink'=>'true', :method => 'delete', :confirm => 'Are you sure you want to delete?'})
  	else
  		link_to(link_raw_field('fa fa-edit'), '#', :disabled => true, :rel=>'tooltip', :title => 'Edit User', :class=>'btn-trans', :data =>{'no-turbolink'=>'true'}) << link_to(link_raw_field('fa fa-ban'), admin_user_path(user), :rel=>'tooltip', :title => 'Delete User', :class=>'btn-trans', :data =>{'no-turbolink'=>'true', :method => 'delete', :confirm => 'Are you sure you want to delete?'})
  	end
  end
end
