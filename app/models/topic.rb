class Topic < ActiveRecord::Base

  @@topic_statuses = ['Published', 'InProcess', 'PartialPublished', 'Saved']

  attr_accessible :title, :description, :course_id, :channel_id, :videos_attributes, :vimeo_album_id, :is_bookmark_video, :password
  cattr_accessor :topic_statuses
  belongs_to :course
  belongs_to :channel
  has_many :videos, :dependent => :destroy
  accepts_nested_attributes_for :videos, :allow_destroy => true

  include Cacheable
  
  validates_lengths_from_database :limit => {:string => 255, :text => 1023}
  validates :course_id, :channel_id, :presence => true
  validates_presence_of :title ,:message => "^Topic can't be blank"
  validates_uniqueness_of :title, :scope => [:course_id, :channel_id] , :message => "^Same topic name has already been taken for this course."
  validate :check_uniqueness_of_title
  validates :status, :inclusion => {:in => @@topic_statuses}

  scope :published, where(:status => ["Published", "PartialPublished"])
  scope :bookmarked, where(:is_bookmark_video => true)
  scope :not_bookmarked, where(:is_bookmark_video => false)

  after_save :update_videos_sphinx_delta
  after_save :change_status

  before_update :change_video_status

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
    update_attribute(:status, "Published") if self.videos.all? {|v| v.published? }
  end


  # def delete_album_and_videos
  #   self.videos.each do |video|
  #     VimeoLib.video.delete(video.try(:vimeo_id))
  #   end
  #   VimeoLib.album.delete(self.vimeo_album_id)
  # end
  # handle_asynchronously :delete_album_and_videos

  def published?
    self.status == "Published"
  end

  def inprocess?
    self.status == "InProcess"
  end

  def upload_to_vimeo
    assign_video = []
    self.videos.where("vimeo_id is ? OR status = ?", nil, 'Saved').each do |video|
      video_data = video.upload
      assign_video << video_data.vimeo_id
    end
    create_album(assign_video) if assign_video.any?
    update_column(:status, "InProcess")
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

  def self.sphinx_search options, current_user, topic_ids=[]
    sort_options, search_options, sphinx_options, select_option = {}, {}, {}, {}
    options[:sSearch] = options[:sSearch].gsub(/([_@#!%()\-=;><,{}\~\[\]\.\/\?\"\*\^\$\+\-]+)/, ' ')
    if topic_ids.blank?
      query = options[:sSearch].blank? ? "" : "#{options[:sSearch]}*"
      page =  options[:iDisplayStart].blank? ? "" : (options[:iDisplayStart].to_i/options[:iDisplayLength].to_i) + 1
      sort_options.merge!(:order => [options["mDataProp_#{options[:iSortCol_0]}"], options[:sSortDir_0]].join(" "))
      unless current_user.is_admin?
        with_permitted_user = "*,IF (channel_admin_user_id = #{current_user.id} OR course_admin_user_id =#{current_user.id},1,0) AS permitted_user"
        select_option.merge!(:select => with_permitted_user)
        search_options.merge!(:with => {"permitted_user" => 1})
      end
      sphinx_options.merge!(sort_options).merge!(select_option).merge!(search_options)

      if options[:sSearch_1] == 'all' && !options[:sSearch].blank?
        condition_string = "@(title,course_name,channel_name) #{options[:sSearch]}*"
        sphinx_options.merge!(:match_mode => :extended)
        Topic.search(condition_string, sphinx_options).page(page).per(options[:iDisplayLength])
      else
        sphinx_options.deep_merge!(:conditions => {options[:sSearch_1] => "#{options[:sSearch]}*"}) if !options[:sSearch_1].blank? and !options[:sSearch].blank? 
        Topic.search(query, sphinx_options).page(page).per(options[:iDisplayLength])
      end
    else
      search_options.deep_merge!(:with => {:topic_id => topic_ids})
      options[:sSearch].blank? ? sphinx_options.merge!(search_options).deep_merge!(:include => [:topic])  : sphinx_options.merge!(search_options).deep_merge!(:conditions => {options[:sSearch_1] => "#{options[:sSearch]}*"}, :include => [:topic]) 
      Topic.search(sphinx_options)      
    end  
  end

  def vimeo_album_url 
    "https://vimeo.com/album/#{self.vimeo_album_id}"
  end

  def validate_uniq_videos options
    qued_for_destroy, validatable_video_attribs = {}, {}
    options[:topic][:videos_attributes].map{|key, value| qued_for_destroy.merge!(key => value) if value["_destroy"] == "1"}
    options[:topic][:videos_attributes].map{|key, value| validatable_video_attribs.merge!(key => value) if value["_destroy"] != "1"}
    sequence_numbers = validatable_video_attribs.map{|k, v| v["sequence_number"]}.compact
    titles = validatable_video_attribs.map{|k, v| v["titles"]}.compact
    errors.add(:base, "Video sequence numbers must be unique.") if sequence_numbers != sequence_numbers.uniq
    errors.add(:base, "Video titles must be unique.") if titles != titles.uniq
    #validate_sequence_videos(sequence_numbers) if errors.blank?
  end

  # Not Using as of now
  def validate_sequence_videos sequence_numbers
    sequence_numbers = sequence_numbers.map { |seq| seq.to_i }
    errors.add(:base, "Video Sequence not valid.") if sequence_numbers.count != sequence_numbers.sort.last 
  end

  def change_video_status
    self.videos.each do |video|
      if video.clip_updated_at_changed?
        video.update_attribute(:status, "Saved")
        video.update_attribute(:vimeo_data, nil)
        video.bookmarks.destroy_all if video.bookmarked?
      end
    end
  end

  def topic_first_video(current_user)
    if (@user_subscription || (current_user && current_user.is_admin?))
      videos = self.videos.published
      return videos.first if videos.any?
    else
      video = self.videos.published.demo_videos
      video = self.course.course_first_video(current_user) if video.blank?
      return video
    end
  end

  def change_status
    update_column(:status,"PartialPublished") if self.videos.pluck(:status).include?("Saved")
    update_column(:status, "Published") if self.videos.all? {|v| v.published? }
    update_column(:status, "Saved") if self.videos.all? {|v| v.saved? }
  end
end