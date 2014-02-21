class Role < ActiveRecord::Base

  @@valid_role_names = ['admin', 'user', 'channel_admin', 'course_admin']
  @@admin_roles = ['admin', 'channel_admin', 'course_admin']

  cattr_accessor :admin_roles
  
  validates_lengths_from_database :limit => {:string => 255, :text => 1023}
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  include Cacheable
  
  scopify

  validates :name, :inclusion => {:in => @@valid_role_names}
end