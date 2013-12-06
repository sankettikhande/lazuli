class Subscription < ActiveRecord::Base
  attr_accessible :name, :days, :months, :years, :calculated_days
  #ASSOCIATIONS

  #VALIDATIONS
  has_many :user_channel_subscriprions
  validates :name, :presence => true

  #SCOPES

  #INSTANCE METHODS

  #CLASS METHODS

end
