class Subscription < ActiveRecord::Base
  attr_accessible :name
  #ASSOCIATIONS

  #VALIDATIONS
  validates :name, :presence => true

  #SCOPES

  #INSTANCE METHODS

  #CLASS METHODS

end
