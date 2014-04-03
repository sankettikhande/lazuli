# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.find_by_name("Lazuli Admin") || User.new(:name => "Lazuli Admin", :email => "admin@lazuli.com", :password => "password", :password_confirmation => "password")
user.skip_confirmation!
if user.save(:validate => false)
  user.add_role(:admin) unless user.has_role? :admin
  user.add_role(:user) unless user.has_role? :user
  user.add_role(:channel_admin)
  user.add_role(:course_admin)
end