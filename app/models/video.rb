class Video < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :title, :description, :summary, :trial, :demo, :sequence_number, :image, :tag_list
  belongs_to :topic
  acts_as_taggable

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => ":class/missing.gif", :path => ":rails_root/public/images/videos/:id/:style/:basename.:extension"

  validates_attachment_size :image, :less_than => 3.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png','image/gif','image/jpg']
end
