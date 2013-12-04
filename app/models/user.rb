class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid , :name, :phone_number, :company_name, :address
  attr_accessible :user_channel_subscriptions_attributes
  has_many :user_channel_subscriptions
  has_many :subscriptions, :through => :user_channel_subscriptions
 
  has_many :channel_permissions, :class_name => UserPermission, :foreign_key => :channel_permission_id
  has_many :course_permissions, :class_name => UserPermission, :foreign_key => :channel_permission_id
 
  accepts_nested_attributes_for :user_channel_subscriptions, :reject_if => lambda { |a| a[:channel_id].blank? || a[:subscription_id].blank? }, :allow_destroy => true


  def self.find_for_oauth(oauth_raw_data, oauth_user_data, signed_in_resource=nil )
    return User.where("(provider = '#{oauth_raw_data.provider}' AND uid = '#{oauth_raw_data.uid}') OR email='#{oauth_user_data.email}'").first || User.create!(name:oauth_user_data.name,
                            provider:oauth_raw_data.provider,
                            uid:oauth_raw_data.uid,
                            email:oauth_user_data.email,
                            password:Devise.friendly_token[0,20],
                          )
  end
  
end