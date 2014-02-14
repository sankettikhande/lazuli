class Channel < ActiveRecord::Base
  attr_accessible :name, :contact_number, :email, :user_name, :channel_type, :company_name, :company_contact_name, :company_postal_address, :company_address, :company_description, :company_number, :admin_user_id, :created_by, :image, :courses_attributes
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
  validates :name, :company_name, :company_number, :email, :presence => true
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, :unless => Proc.new {|c| c.email.blank?}
  validates :admin_user_id, :presence => {:message => "Full name can't be blank."}
  validates_attachment_size :image, :less_than => 3.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png','image/gif','image/jpg']
  validates_uniqueness_of :name, :message => "^Channel name has already been taken."
  accepts_nested_attributes_for :courses, :reject_if => :all_blank, :allow_destroy => true

  #SCOPES
  after_save :set_channel_permission, :on => :create
  after_save :update_topics_sphinix_deltas
  after_destroy :remove_channel_admin_role
  before_save :update_channel_admin_user_ids, :if => :admin_user_id_changed?
  after_create :user_assign_role

  #INSTANCE METHODS
  def subscription_types
    Subscription.all.map(&:name).join(", ")
  end

  #CLASS METHODS
  def self.public_channels
    Channel.where(:channel_type => 'public').joins(:courses =>[:topics]).includes(:courses => [:topics]).where("topics.status = ?", 'Published')
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
    u = User.find self.admin_user_id
    u.remove_role "channel_admin" if u.administrated_channels.blank?
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

  def self.sphinx_search options, current_user
    sphinx_options, sort_options, search_options = {}, {}, {}
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
  end
end
