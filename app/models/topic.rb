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
  validates_uniqueness_of :title, :scope => [:course_id, :channel_id]
  validate :check_uniqueness_of_title


  def create_album_for_single_video(video)
    album = VimeoLib.album.create(self.title, video.vimeo_id, {:description => self.description })
    self.vimeo_album_id = album['album'].first['id']
    self.save
    set_password_to_album
  end


  def check_uniqueness_of_title
    video_titles = videos.map(&:title)
    if(video_titles.length != video_titles.uniq.length)
      errors.add(:base, 'Video title must be unique')
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

  def upload_to_vimeo
    assign_video = []
    self.videos.where(:vimeo_id => nil).each do |video|      
      video_data = video.upload
      assign_video << video_data.vimeo_id
    end
    create_album(assign_video) if assign_video.any?
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
    self.update_attribute(:status, "Publish")
  end

  def self.sphinx_search options
    query = options[:sSearch].blank? ? "" : "#{options[:sSearch]}*"
    page = (options[:iDisplayStart].to_i/options[:iDisplayLength].to_i) + 1
    sort_options = [options["mDataProp_#{options[:iSortCol_0]}"], options[:sSortDir_0]].join(" ")
    Topic.search(query, :order => sort_options, :sql => {:include => [:course, :channel]}).page(page).per(options[:iDisplayLength])
  end

  def vimeo_album_url 
    "https://vimeo.com/album/#{self.vimeo_album_id}"
  end
end