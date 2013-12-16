class Video < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :title, :description, :summary, :trial, :demo, :sequence_number, :image, :tag_list, :clip
  belongs_to :topic
  acts_as_taggable

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, 
  									:default_url => ":class/missing.gif", 
  									:path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
  									:url => "/system/:class/:attachment/:id/:style/:basename.:extension"

  has_attached_file :clip,
                    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
                    :url => "/system/:class/:attachment/:id/:style/:basename.:extension"

  validates :title, :description, :presence => true
  validates_attachment_size :image, :less_than => 3.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png','image/gif','image/jpg']
  validates_attachment_size :clip, :less_than => 500.megabytes, :message => 'filesize must be less than 500 MegaBytes'
end

def upload_to_vimeo
  vimeo_video_id = VimeoLib.upload.upload(self.clip)["ticket"]["video_id"]
  self.vimeo_id = vimeo_video_id
  v = VimeoLib.video
  v.set_description(self.vimeo_id,self.description)
  v.add_tags(self.vimeo_id,self.tag_list) if !self.taglist.blank?
  v.set_title(self.vimeo_id, self.title)
end

def delete_vimeo_video
  VimeoLib.video.delete(self.vimeo_id)
end

