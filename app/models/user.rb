class User < ActiveRecord::Base
  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid , :name, :phone_number, :company_name, :address, :actual_name
  attr_accessible :user_channel_subscriptions_attributes
  has_many :user_channel_subscriptions
  has_many :subscriptions, :through => :user_channel_subscriptions
 
  include Cacheable

  accepts_nested_attributes_for :user_channel_subscriptions, :reject_if => :all_blank, :allow_destroy => true


  def self.find_for_oauth(oauth_raw_data, oauth_user_data, signed_in_resource=nil )
    return User.where("(provider = '#{oauth_raw_data.provider}' AND uid = '#{oauth_raw_data.uid}') OR email='#{oauth_user_data.email}'").first || User.create!(name:oauth_user_data.name,
                            provider:oauth_raw_data.provider,
                            uid:oauth_raw_data.uid,
                            email:oauth_user_data.email,
                            password:Devise.friendly_token[0,20],
                          )
  end

end