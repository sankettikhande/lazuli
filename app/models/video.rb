include VimeoLib
class Video < ActiveRecord::Base
  # attr_accessible :title, :body
  serialize :vimeo_data
  attr_accessible :title, :description, :summary, :trial, :demo, :sequence_number, :image, :tag_list, :clip, :vimeo_id, :vimeo_data, :vimeo_url
  belongs_to :topic
  acts_as_taggable

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, 
  									:default_url => ":class/:style/missing.gif", 
  									:path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
  									:url => "/system/:class/:attachment/:id/:style/:basename.:extension"

  has_attached_file :clip,
                    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
                    :url => "/system/:class/:attachment/:id/:style/:basename.:extension"

  validates :title, :description, :presence => true
  validates_attachment_size :image, :less_than => 3.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png','image/gif','image/jpg']
  validates_attachment_size :clip, :less_than => 500.megabytes, :message => 'Filesize must be less than 500 MegaBytes'
  validates_uniqueness_of :title, :scope => :topic_id

  def upload_to_vimeo
    topic = self.topic
    assign_vedio = []
    topic.videos.each do |video|
      if !video.vimeo_id
        vedio_data = upload(video)
        assign_vedio << vedio_data.vimeo_id
      end
    end
    create_album(topic, assign_vedio) if assign_vedio.any?
  end
  handle_asynchronously :upload_to_vimeo

  def delete_vimeo_video
    VimeoLib.video.delete(self.vimeo_id)
  end

  def remove_video_from_album
    VimeoLib.album.remove_video(self.topic.vimeo_album_id,self.vimeo_id)
  end

  def create_album(topic, assign_vedio)
    if topic.vimeo_album_id.blank?
      album = VimeoLib.album.create(topic.title, assign_vedio.first, {:description => topic.description, :videos => assign_vedio.join(",") })
      topic.vimeo_album_id = album['album'].first['id']
      topic.save
    else
      assign_vedio.each do |vimeo_id|
        VimeoLib.album.add_video(topic.vimeo_album_id, vimeo_id)
      end
    end
  end

  def upload(video)
    video.vimeo_id = VimeoLib.upload.upload(video.clip.path)["ticket"]["video_id"]
    v = VimeoLib.video
    v.set_description(video.vimeo_id,video.description)
    v.add_tags(video.vimeo_id,video.tag_list.join(",")) if !video.tag_list.blank?
    v.set_title(video.vimeo_id, video.title)
    vimeo_data = v.get_info(video.vimeo_id)
    video.vimeo_data = vimeo_data
    video.vimeo_url = hashie_get_info(vimeo_data).video.first.urls.url.first._content if vimeo_data
    video.save!
    return video
  end

  def hashie_get_info(vimeo_data)
    Hashie::Mash.new(vimeo_data)
  end
end


