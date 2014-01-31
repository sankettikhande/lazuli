class Subscription < ActiveRecord::Base
  attr_accessible :name, :days, :months, :years, :calculated_days
  #ASSOCIATIONS

  #VALIDATIONS
  has_many :user_channel_subscriprions
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
