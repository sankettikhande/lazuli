json.set! :data do
	json.id @user.id
	json.name @user.name
	json.email @user.email
	json.phone_number @user.phone_number
	json.actual_name @user.actual_name
end