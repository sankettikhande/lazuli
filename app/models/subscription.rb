class Subscription < ActiveRecord::Base
  attr_accessible :name, :days, :months, :years, :calculated_days, :price , :is_trial_subscription
  #ASSOCIATIONS
  has_many :user_channel_subscriprions

  #VALIDATIONS
  validates_lengths_from_database :limit => {:string => 255, :text => 1023}
  validates :name, :presence => true

  include Cacheable
  
  before_save :set_calulated_days

  #SCOPES

  #INSTANCE METHODS
  def set_calulated_days
  	self.calculated_days = self.days.to_i + 30*self.months.to_i + 365*self.years.to_i
  end	
  
  #CLASS METHODS

end
