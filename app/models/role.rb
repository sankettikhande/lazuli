class Role < ActiveRecord::Base

  @@valid_role_names = ['admin', 'user', 'channel_admin']

  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true
  
  scopify

  validates :name, :inclusion => {:in => @@valid_role_names}
end
