json.set! :data do
	json.array! @users, :id, :name, :email, :phone_number
end