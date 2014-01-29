class Favourite < ActiveRecord::Base

	@@favouritable_types = ["Course", "Topic", "Video"]

  belongs_to :favouritable, :polymorphic => true
  belongs_to :user

  attr_accessible :favouritable_id, :favouritable_type, :user_id
  cattr_accessor :favouritable_types

  validates :favouritable_type, :inclusion => {:in => self.favouritable_types, :message => "should be either of ('Course', 'Topic', 'Video')"}

  scope :videos, where(:favouritable_type => "Video")
end
