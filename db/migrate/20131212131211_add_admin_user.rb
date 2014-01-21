class AddAdminUser < ActiveRecord::Migration
  def up
    # user = User.new(:name => "Lazuli Admin", :email => "admin@lazuli.com", :password => "password", :password_confirmation => "password")
    # user.skip_confirmation!
    # if user.save(:validate => false)
    #   user.add_role(:admin)
    #   user.add_role(:user)
    # end
  end

  def down
    User.find_by_email("admin@lazuli.com").try(:destroy)
  end
end
