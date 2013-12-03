class Channel < ActiveRecord::Base
  attr_accessible :name, :contact_number, :email, :user_name, :channel_type, :company_name, :company_contact_number, :company_address, :company_description, :company_number, :admin_user_id, :created_by
  #ASSOCIATIONS
  has_many :channel_courses
  has_many :courses, :through => :channel_courses
  has_many :channel_subscriptions
  has_many :subscriptions, :through => :channel_subscriptions

  belongs_to :admin, :class_name => User, :foreign_key => :admin_user_id
  belongs_to :creator, :class_name => User, :foreign_key => :created_by

  #VALIDATIONS
  validates :name, :presence => true

  #SCOPES


  #INSTANCE METHODS
  

  #CLASS METHODS
end
