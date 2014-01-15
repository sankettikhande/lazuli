include VimeoLib
class Video < ActiveRecord::Base
  # attr_accessible :title, :body
  serialize :vimeo_data
  attr_accessible :title, :description, :summary, :trial, :demo, :sequence_number, :image, :tag_list, :clip, :vimeo_id, :vimeo_data, :vimeo_url, :password, :bookmarks_attributes
  attr_accessor :bookmarks_from_params
  has_many :bookmarks, :dependent => :destroy
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
  validates_presence_of :clip
  accepts_nested_attributes_for :bookmarks, :allow_destroy => true

  def upload_single_video
    video = self.upload if self.vimeo_id.blank?
    video.topic.create_album_for_single_video(video) if video.topic.vimeo_album_id.blank?
    VimeoLib.album.add_video(video.topic.vimeo_album_id, video.vimeo_id)
    video.topic.set_status
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
    self.status = "Publish"
    self.vimeo_url = vimeo_video_url
    self.save!
    publish_privately
    return self
  end

  def hashie_get_info(vimeo_data)
    Hashie::Mash.new(vimeo_data)
  end

  def description_text
    text = []
    self.bookmarks.each do |desc_text|
      text << "#{desc_text.title} #{desc_text.time}"
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

  def inprocess?
    self.status == "InProcess"
  end

  def publish_privately
    password =  ((0...4).map{ ('A'..'Z').to_a[rand(26)] } + (0...4).map{ ('a'..'z').to_a[rand(26)] } + (0...3).map{ (0..9).to_a[rand(9)] }).shuffle.join
    VimeoLib.video.set_privacy(vimeo_id, "password", {:password => password})
    update_attribute(:password,password)
  end

  def self.sphinx_search options, current_user
    sort_options, search_options, sql_options, sphinx_options = {}, {}, {}, {}
    query = options[:sSearch].blank? ? "" : "#{options[:sSearch]}*"
    page = (options[:iDisplayStart].to_i/options[:iDisplayLength].to_i) + 1
    sort_options.merge!(:order => [options["mDataProp_#{options[:iSortCol_0]}"], options[:sSortDir_0]].join(" "))

    search_options.merge!(:with =>{ "video_id" => current_user.administrated_channel_video_ids}) unless current_user.is_admin?
    sql_options.merge!(:sql => {:include => [{:topic => [:channel, :course]}, :tags]})
    sphinx_options.merge!(sort_options).merge!(search_options).merge!(sql_options)
    Video.search(query,sphinx_options ).page(page).per(options[:iDisplayLength])
  end

  def vimeo_video_url
    !self.vimeo_id.nil? ? "http://vimeo.com/#{self.vimeo_id}" : nil 
  end

  def process_bookmark
    bookmarks = []
    self.bookmarks_from_params.each do |bookmark|
      if bookmark['id']
        bookmark_obj = Bookmark.find(bookmark['id'])
        bookmark_obj.time = bookmark['time']
        bookmark_obj.title = bookmark['title']
        bookmark_obj.description = bookmark['description']
      else
        bookmark_obj = Bookmark.new(bookmark)
      end
      bookmarks << bookmark_obj
    end
    bookmarks
  end

  def validate_bookmark bookmarks
    bookmarks.all? { |bookmark| bookmark.valid? }
  end
end


