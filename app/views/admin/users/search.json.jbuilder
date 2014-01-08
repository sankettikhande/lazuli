json.aaData @users do |user|
  json.(user, :id, :name, :email, :phone_number, :actual_name, :company_name, :address, :confirm_status)
  json.actions user_actions(user)
end
json.sEcho params[:sEcho].to_i
json.iTotalRecords  @users.count
json.iTotalDisplayRecords @users.count
