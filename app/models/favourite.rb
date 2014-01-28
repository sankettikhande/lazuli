class Favourite < ActiveRecord::Base
  belongs_to :favouritable, :polymorphic => true
  belongs_to :user
  attr_accessible :favouritable_id, :favouritable_type, :user_id

  scope :videos, where(:favouritable_type => "Video")
end
