class Channel < ActiveRecord::Base
  attr_accessible :name, :contact_number, :email, :user_name, :channel_type, :company_name, :company_contact_name, :company_postal_address, :company_address, :company_description, :company_number, :admin_user_id, :created_by, :image, :courses_attributes, :website, :facebook_page, :twitter_page
  # attr_accessible :courses_attributes

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, 
                  :default_url => ":class/:style/missing.gif", 
                  :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
                  :url => "/system/:class/:attachment/:id/:style/:basename.:extension"

  #ASSOCIATIONS
  has_many :courses, :dependent => :destroy
  has_many :channel_course_permissions, :dependent => :destroy
  has_many :user_channel_subscriptions, :dependent => :destroy

  include Cacheable
  
  belongs_to :admin, :class_name => User, :foreign_key => :admin_user_id
  belongs_to :creator, :class_name => User, :foreign_key => :created_by

  #VALIDATIONS
  validates_presence_of :image, :message => "^Please upload the company logo."
  validates_lengths_from_database :limit => {:string => 255, :text => 1023}
  validates :user_name, :company_name, :company_number, :email, :presence => true
  validates_presence_of :name, :message => "^Channel name cann't be blank"
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, :unless => Proc.new {|c| c.email.blank?}
  validates :admin_user_id, :presence => {:message => "Full name can't be blank."}
  validates_attachment_size :image, :less_than => 3.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png','image/gif','image/jpg']
  validates_uniqueness_of :name, :message => "^Channel name has already been taken."
  validates :website, :facebook_page, :twitter_page, :format => {:with =>  URI::regexp(%w(http https))}, :allow_blank => true
  accepts_nested_attributes_for :courses, :reject_if => :all_blank, :allow_destroy => true

  #SCOPES
  after_save :set_channel_permission, :on => :create
  after_save :update_topics_sphinix_deltas
  after_destroy :remove_channel_admin_role
  before_save :update_channel_admin_user_ids, :if => :admin_user_id_changed?
  after_create :user_assign_role

  scope :publicChannels, where(:channel_type => 'public')
  scope :privateChannels, where(:channel_type => 'private')


  #INSTANCE METHODS
  def subscription_types
    Subscription.all.map(&:name).join(", ")
  end

  #CLASS METHODS
  def self.public_channels
    Channel.publicChannels.joins(:courses =>[:topics]).includes(:courses => [:topics]).where("topics.status in (?)", ['Published', 'PartialPublished'])
  end
    
  def published_topic_courses
    Course.includes(:channel, :topics).where("topics.status in (?) AND channels.channel_type = ? AND courses.channel_id = ? ", ['Published', 'PartialPublished'], 'public', self.id)
  end

  def channel_admin_user
    self.admin ? self.admin.actual_name.titleize : ''
  end

  def add_subscription_destroy_key course_subscriptions_params
    course_subscriptions_params.each {|k, v| v.each {|a, b| b.each {|c, d| d.merge!(:_destroy => 1) unless d.has_key?("subscription_id")} if a == 'course_subscriptions_attributes'}}
  end

  def set_channel_permission
    self.courses.each do |course|
      course.channel_course_permissions.each do |permission|
        permission.channel_id = self.id
        permission.save
      end
    end
  end

  def update_channel_admin_user_ids
    User.eliminate_role(self.admin_user_id_was,:channel_admin, :channel => self) unless self.admin_user_id_was.blank?
    User.assign_role(admin_user_id, :channel_admin)
    self.courses.includes(:topics =>[:videos]).each do |course|
      course.update_attribute(:channel_admin_user_id, admin_user_id)
      course.topics.each do |topic| 
        topic.update_attribute(:channel_admin_user_id, admin_user_id)
        topic.videos.map {|video| video.update_attribute(:channel_admin_user_id,admin_user_id)}
      end
    end
  end

  def remove_channel_admin_role
    User.eliminate_role(self.admin_user_id,:channel_admin)
  end

  def permitted_courses current_user
    user_id = current_user.id
    if current_user.is_admin? || self.admin_user_id == user_id
      permitted_courses = self.courses
    else
      permitted_courses = self.courses.where(:course_admin_user_id => user_id)
    end      
  end

  # updates topics indices
  def update_topics_sphinix_deltas
    courses.each do | c |
      c.delta = true
      c.save
    end
  end

  def user_assign_role
    User.assign_role(self.admin_user_id, :channel_admin)
  end

  def users_for_channel
    user_channel_subscriptions.blank? ? "-" : user_channel_subscriptions.count
  end

  def self.sphinx_search options, current_user, channel_type = ""
    sphinx_options, sort_options, search_options = {}, {}, {}
    if channel_type.blank?
      options[:sSearch] = options[:sSearch].gsub(/([_@#!%()\-=;><,{}\~\[\]\.\/\?\"\*\^\$\+\-]+)/, ' ')
      query = options[:sSearch].blank? ? "" : "#{options[:sSearch]}*"
      page = (options[:iDisplayStart].to_i/options[:iDisplayLength].to_i) + 1
      sort_options.merge!(:order => [options["mDataProp_#{options[:iSortCol_0]}"], options[:sSortDir_0]].join(" "))
      unless current_user.is_admin?
        accessible_channel_ids = current_user.administrated_channel_ids
        return [] if accessible_channel_ids.blank?
        search_options.merge!(:with => {"channel_id" => current_user.administrated_channel_ids}) 
      end
      sphinx_options.merge!(sort_options).merge!(search_options)
      if options[:sSearch_1] == 'all' && !options[:sSearch].blank?
        condition_string = "@(name) #{options[:sSearch]}*"
        sphinx_options.merge!(:match_mode => :extended)
        Channel.search(condition_string, sphinx_options).page(page).per(options[:iDisplayLength])
      else
        sphinx_options.deep_merge!(:conditions => {options[:sSearch_1] => "#{options[:sSearch]}*"}) if !options[:sSearch_1].blank? and !options[:sSearch].blank? 
        Channel.search(query, sphinx_options).page(page).per(options[:iDisplayLength])
      end
    else
      page = options[:page] || 1
      options[:sSearch] = options[:sSearch] || ""
      options[:iDisplayLength] = options[:iDisplayLength] || 15
      search_options.deep_merge!(:conditions => {:channel_type => channel_type})
      condition_string = "@(name) #{options[:sSearch]}*"
      sphinx_options.merge!(search_options).deep_merge!(:sql => {:joins => {:courses => :topics}, :include => {:courses => :topics}}, :conditions => {:topic_status => 'Published'})
      Channel.search(condition_string, sphinx_options).page(page).per(options[:iDisplayLength])
    end
  end
end
