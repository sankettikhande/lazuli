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
  validates_uniqueness_of :title, :scope => :topic_id
  validates_attachment_size :image, :less_than => 3.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png','image/gif','image/jpg']
  validates_attachment_size :clip, :less_than => 500.megabytes, :message => 'Filesize must be less than 500 MegaBytes'

  def upload_single_video
    video_data = upload
    VimeoLib.album.add_video(self.topic.vimeo_album_id, video_data.vimeo_id)
  end

  handle_asynchronously :upload_single_video

  def delete_vimeo_video
    VimeoLib.video.delete(self.vimeo_id)
  end

  def remove_video_from_album
    VimeoLib.album.remove_video(self.topic.vimeo_album_id,self.vimeo_id)
  end

  def upload
    self.vimeo_id = VimeoLib.upload.upload(self.clip.path)["ticket"]["video_id"]
    v = VimeoLib.video
    set_vimeo_description(self.vimeo_id, self.description_text)
    v.add_tags(self.vimeo_id,self.tag_list.join(",")) if !self.tag_list.blank?
    v.set_title(self.vimeo_id, self.title)
    vimeo_data = v.get_info(self.vimeo_id)
    self.status = "Publish"
    self.vimeo_data = vimeo_data
    self.vimeo_url = hashie_get_info(vimeo_data).video.first.urls.url.first._content if vimeo_data
    self.save!
    return self
  end

  def hashie_get_info(vimeo_data)
    Hashie::Mash.new(vimeo_data)
  end

  def description_text
    text = []
    desc = self.bookmark ? JSON.parse(self.bookmark) : {}
    desc.each do |desc_text|
      text << "#{desc_text['description']} #{desc_text['time']}"
    end
    "#{self.description} #{text.join(', ')}"
  end

  def set_vimeo_description(vimeo_id, description_text)
    object = VimeoLib.video
    object.set_description(vimeo_id, description_text)
  end

  def published?
    self.status == "Publish"
  end

  def self.sphinx_search options
    query = options[:sSearch].blank? ? "" : "#{options[:sSearch]}*"
    page = (options[:iDisplayStart].to_i/options[:iDisplayLength].to_i) + 1
    sort_options = [options["mDataProp_#{options[:iSortCol_0]}"], options[:sSortDir_0]].join(" ")
    Video.search(query, :order => sort_options).page(page).per(options[:iDisplayLength])
  end
end


