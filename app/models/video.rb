include VimeoLib
class Video < ActiveRecord::Base
  # attr_accessible :title, :body
  serialize :vimeo_data
  serialize :thumbnail_data
  attr_accessible :title, :description, :summary, :trial, :demo, :sequence_number, :image, :tag_list, :clip, :vimeo_id, :vimeo_data, :vimeo_url, :password, :bookmarks_attributes, :thumbnail_data
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
  validates_attachment_size :image, :less_than => 3.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png','image/gif','image/jpg']
  validates_attachment_size :clip, :less_than => 500.megabytes, :message => 'Filesize must be less than 500 MegaBytes'
  validates_presence_of :clip
  accepts_nested_attributes_for :bookmarks, :allow_destroy => true
  
  after_save :update_bookmarks

  def upload_single_video
    video = self.upload
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
    get_thumbnails
    return self
  end

  def hashie_get_info(vimeo_data)
    Hashie::Mash.new(vimeo_data)
  end

  def get_thumbnails
    thumbnail_data = VimeoLib.video.get_thumbnail_urls(vimeo_id)
    thumbnails = hashie_get_info(thumbnail_data).thumbnails
    update_attribute(:thumbnail_data, thumbnails)
  end
  handle_asynchronously :get_thumbnails ,:run_at => Proc.new{30.minutes.from_now}

  def get_best_thumbnail
    thumbnail_data.thumbnail[2]._content unless thumbnail_data.blank?
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
    search_options.merge!(:conditions =>{ "course_id" => options[:course_id]}) if !options[:course_id].blank?
    search_options.merge!(:conditions =>{ "topic_id" => options[:topic_id]}) if !options[:topic_id].blank?
    unless current_user.is_admin?
      accessible_video_ids = current_user.administrated_channel_video_ids
      return [] if accessible_video_ids.blank?
      search_options.merge!(:with =>{ "video_id" => current_user.administrated_channel_video_ids}) 
    end
    sql_options.merge!(:sql => {:include => [{:topic => [:channel, :course]}, :tags]})
    sphinx_options.merge!(sort_options).merge!(search_options).merge!(sql_options)
    sphinx_options.merge!(:conditions => {options[:sSearch_1] => "#{options[:sSearch]}*"}) if !options[:sSearch_1].blank? and !options[:sSearch].blank?
    Video.search(query, sphinx_options).page(page).per(options[:iDisplayLength])
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

  def update_bookmarks
    Bookmark.update_ending_at(self) if self.topic.is_bookmark_video
    self.set_vimeo_description(self.vimeo_id, self.description_text) if self.vimeo_id
  end

  def unique_bookmarks(params)
    time_elements = params[:video][:bookmarks_attributes].map{ |a,b| b }.map{ |bookmark| bookmark[:time] if bookmark["_destroy"] == "false" }.compact
    destroy_elements = params[:video][:bookmarks_attributes].map{ |a,b| b }.map{ |bookmark| bookmark[:time] if bookmark["_destroy"] == "1" }.compact
    time_elements.size == time_elements.uniq.size ? true : self.errors.add(:base, 'Bookmarks time has already been taken')
    validate_uniqueness_bookmarks(params[:video][:bookmarks_attributes].map{ |a,b| b }.map{ |bookmark| [bookmark[:id], bookmark[:time]] if bookmark["_destroy"] == "false" }.compact, destroy_elements)
  end

  def validate_uniqueness_bookmarks(time_elements, destroy_elements)
    time_elements.each do |id, time|
      if destroy_elements.any?
        unless destroy_elements.include?(time)
          self.errors.add(:base, 'Bookmarks time has already been taken') if id.nil? && !Bookmark.where(:video_id => self.id, :time => time).count.zero?
        end
      else
        self.errors.add(:base, 'Bookmarks time has already been taken') if id.nil? && !Bookmark.where(:video_id => self.id, :time => time).count.zero?
      end
    end
  end
end
