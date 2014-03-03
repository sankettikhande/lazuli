class ContactUs < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :email, :subject, :message  
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, :unless => Proc.new {|c| c.email.blank?}
end
