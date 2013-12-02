class Channel < ActiveRecord::Base
  # attr_accessible :title, :body
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
