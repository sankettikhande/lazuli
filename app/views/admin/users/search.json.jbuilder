json.aaData @users do |user|
  json.name link_to(user.name, edit_admin_user_url(user))
  json.(user, :email, :phone_number, :actual_name, :company_name, :address, :confirm_status)
  json.actions user_actions(user)
end
json.sEcho params[:sEcho].to_i
json.iTotalRecords  @users.blank? ? 0 : @users.total_entries
json.iTotalDisplayRecords @users.blank? ? 0 : @users.total_entries
