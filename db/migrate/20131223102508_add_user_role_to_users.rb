class AddUserRoleToUsers < ActiveRecord::Migration
  def change
    User.all.each do |user|
      user.add_role(:user) unless user.is_user?
    end
  end
end
