class Topic < ActiveRecord::Base
  attr_accessible :title, :description, :course_id, :channel_id, :videos_attributes, :vimeo_album_id, :is_bookmark_video, :password
  belongs_to :course
  belongs_to :channel
  has_many :videos, :dependent => :destroy
  belongs_to :channel
  accepts_nested_attributes_for :videos, :allow_destroy => true

  include Cacheable

  validates :course_id, :channel_id, :presence => true
  validates_presence_of :title ,:message => "^Topic can't be blank"
  validates_uniqueness_of :title, :scope => [:course_id, :channel_id] , :message => "^Same topic name has already been taken for this course."
  validate :check_uniqueness_of_title

  after_save :update_videos_sphinx_delta

  def update_videos_sphinx_delta
    videos.each do |v|
      v.delta = true
      v.save
    end
  end


  def create_album_for_single_video(video)
    album = VimeoLib.album.create(self.title, video.vimeo_id, {:description => self.description })
    self.vimeo_album_id = album['album'].first['id']
    self.save
    set_password_to_album
  end


  def check_uniqueness_of_title
    video_titles = videos.map(&:title)
    if(video_titles.length != video_titles.uniq.length)
      errors.add(:base, 'Videos title must be unique.')
    end 
  end

  def set_password_to_album
    password = ((0...4).map{ ('A'..'Z').to_a[rand(26)] } + (0...4).map{ ('a'..'z').to_a[rand(26)] } + (0...3).map{ (0..9).to_a[rand(9)] }).shuffle.join
    VimeoLib.album.set_password(self.vimeo_album_id , password)
    self.update_attribute(:password, password)
  end

  def set_status
    update_attribute(:status, "Publish") if self.videos.all? {|v| v.published? }
  end


  # def delete_album_and_videos
  #   self.videos.each do |video|
  #     VimeoLib.video.delete(video.try(:vimeo_id))
  #   end
  #   VimeoLib.album.delete(self.vimeo_album_id)
  # end
  # handle_asynchronously :delete_album_and_videos

  def published?
    self.status == "Publish"
  end

  def inprocess?
    self.status == "InProcess"
  end

  def upload_to_vimeo
    assign_video = []
    self.videos.where(:vimeo_id => nil).each do |video|      
      video_data = video.upload
      assign_video << video_data.vimeo_id
    end
    create_album(assign_video) if assign_video.any?
    self.update_attribute(:status, "Publish")
  end
  handle_asynchronously :upload_to_vimeo

  def create_album(assign_video)
    if self.vimeo_album_id.blank?
      album = VimeoLib.album.create(self.title, assign_video.first, {:description => self.description, :videos => assign_video.join(",") })
      self.vimeo_album_id = album['album'].first['id']
      self.save
      set_password_to_album
    else
      assign_video.each do |vimeo_id|
        VimeoLib.album.add_video(self.vimeo_album_id, vimeo_id)
      end
    end
  end

  def self.sphinx_search options, current_user
    sort_options, search_options, sql_options, sphinx_options = {}, {}, {}, {}
    query = options[:sSearch].blank? ? "" : "#{options[:sSearch]}*"
    page = (options[:iDisplayStart].to_i/options[:iDisplayLength].to_i) + 1
    sort_options.merge!(:order => [options["mDataProp_#{options[:iSortCol_0]}"], options[:sSortDir_0]].join(" "))
    unless current_user.is_admin?
      accessible_channel_ids = current_user.administrated_channel_ids
      return [] if accessible_channel_ids.blank?
      search_options.merge!(:with => {"channel_id" => accessible_channel_ids}) 
    end
    sql_options.merge!(:sql => {:include => [:course, :channel]})
    sphinx_options.merge!(sort_options).merge!(search_options).merge!(sql_options)
    Topic.search(query, sphinx_options).page(page).per(options[:iDisplayLength])
  end

  def vimeo_album_url 
    "https://vimeo.com/album/#{self.vimeo_album_id}"
  end
end