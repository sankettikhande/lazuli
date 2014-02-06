class User < ActiveRecord::Base
  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid , :name, :phone_number, :company_name, :address, :actual_name, :created_by
  attr_accessible :user_channel_subscriptions_attributes
  has_many :user_channel_subscriptions, :dependent => :destroy, :before_add => :set_nest
  has_many :subscriptions, :through => :user_channel_subscriptions
  has_many :administrated_channels, :class_name => Channel, :foreign_key => :admin_user_id
  has_many :administrated_courses, :class_name => Course, :foreign_key => :course_admin_user_id
  has_many :favourites, :dependent => :destroy
  has_many :watch_lists, :dependent => :destroy
  validates_presence_of :actual_name, :message => "^Full name can't be blank"
  validates_presence_of :name, :message => "^User name can't be blank"
  validate :subscription_params
  include Cacheable

  accepts_nested_attributes_for :user_channel_subscriptions, :reject_if => :all_blank, :allow_destroy => true

  after_create :add_user_role
  after_save :set_course_admin_role, :set_course_admin_user_id

  def confirm_status
    self.confirmed_at.blank? ? 'Awaiting confirmation' : 'Confirmed'
  end

  def is_any_admin?
    role_names = roles.map(&:name)
    !(role_names & Role.admin_roles).blank?
  end

  def add_user_role
    add_role(:user) if roles.blank?
  end

  def created_users_ids
    User.where(:created_by => id).select(:id).map(&:id)
  end

  def administrated_channel_ids
    administrated_channels.select(:id).map(&:id)
  end

  def administrated_course_ids
    administrated_courses.select(:id).map(&:id) 
  end

  def administrated_channel_subscriber_ids
    UserChannelSubscription.where(:channel_id => administrated_channel_ids).select("DISTINCT user_id").map(&:user_id)
  end

  def administrated_course_subscriber_ids
    UserChannelSubscription.where(:course_id => administrated_course_ids).select("DISTINCT user_id").map(&:user_id)
  end

  def administrated_channel_course_ids
    ChannelCourse.where(:channel_id => administrated_channel_ids).select("DISTINCT course_id").map(&:course_id)
  end

  def administrated_channel_topic_ids
    Topic.where(:channel_id => administrated_channel_ids).select(:id).map(&:id)
  end

  def administrated_course_topic_ids
    Topic.where(:course_id => administrated_course_ids).select(:id).map(&:id)
  end

  def administrated_channel_video_ids
    Video.where(:Topic_id => administrated_channel_topic_ids).select(:id).map(&:id)
  end

  def administrated_course_video_ids
    Video.where(:Topic_id => administrated_course_topic_ids).select(:id).map(&:id)
  end


  def administrator_channel_subscribers
    User.find(administrated_channel_subscriber_ids)
  end

  def subscribed_course_ids
    self.user_channel_subscriptions.pluck("course_id")
  end

  def subscribed_courses
     Course.joins(:user_channel_subscriptions).where(user_channel_subscriptions: {user_id: self.id})
  end

  def list_subscribed_videos
    subscribed_videos = []
    self.subscribed_courses.includes(topics: [:videos]).each do |course|
      course.topics.each {|topic| subscribed_videos << topic.videos}
    end
    return subscribed_videos.flatten
  end

  def subscribed_video_ids
    self.list_subscribed_videos.map(&:id)
  end

  def permitted_channels
    if self.is_admin?
      Channel.all
    else
      Channel.joins(:courses).where("courses.channel_admin_user_id =? OR courses.course_admin_user_id = ?", self.id, self.id).group(:id)
    end
  end

  def self.find_for_oauth(oauth_raw_data, oauth_user_data, signed_in_resource=nil )
    return User.where("(provider = '#{oauth_raw_data.provider}' AND uid = '#{oauth_raw_data.uid}') OR email='#{oauth_user_data.email}'").first || User.create!(name:oauth_user_data.name,
                            actual_name:oauth_user_data.name,
                            provider:oauth_raw_data.provider,
                            uid:oauth_raw_data.uid,
                            email:oauth_user_data.email,
                            password:Devise.friendly_token[0,20],
                          )
  end

  def self.header_attributes(header)
    hash = {"User Name" => "name", "Full Name" => "actual_name", "Password" => "password","Email" => "email", "Phone Number" => "phone_number", "Address" => "address"}
    header.collect {|h| hash[h]}
  end

  def self.import_users(user, admin_user_id)
    user_channel = user[:user_channel_subscriptions_attributes] || {}
    file =  user[:file]
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    header = header_attributes(header)
    user_array = []
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user = User.new((row.to_hash.slice(*accessible_attributes)).merge(:company_name => user[:company_name]))
      user.created_by = admin_user_id
      user_channel.each do |key, val|
        user.user_channel_subscriptions.build(val)
      end
      user_array.push(user)
    end
    user_array
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.bulksheet_errors(bulksheet)
    errors = []
    if bulksheet.blank?
      errors.push("Please upload an Excel file.") 
    else
      file_extension = File.extname(bulksheet.original_filename)
      if !(file_extension == ".xls" || file_extension == ".xlsx")
        errors.push("Invalid file type: #{bulksheet.original_filename}. File format should be '.xls' or '.xlsx'.")
      else
        errors.push("Uploaded excel file is empty.") if (open_spreadsheet(bulksheet).last_row.blank? || open_spreadsheet(bulksheet).last_row < 2)
      end
    end
    errors
  end

  def self.sphinx_search options, current_user
    sphinx_options, search_options, sort_options = {}, {}, {}
    options[:sSearch] = options[:sSearch].gsub(/([_@#!%()\-=;><,{}\~\[\]\.\/\?\"\*\^\$\+\-]+)/, ' ')
    query = options[:sSearch].blank? ? "" : "#{options[:sSearch]}*"
    page = (options[:iDisplayStart].to_i/options[:iDisplayLength].to_i) + 1
    sort_column_direction = [options["mDataProp_#{options[:iSortCol_0]}"], options[:sSortDir_0]].join(" ")
    sort_options.merge!(:order => sort_column_direction)
    unless current_user.is_admin?
      accessible_user_ids = current_user.administrated_channel_subscriber_ids << current_user.created_users_ids
      accessible_ids = accessible_user_ids.flatten.uniq
      return [] if accessible_ids.blank?
      search_options.merge!(:with => {"user_id" => accessible_ids}) 
    end
    sphinx_options.merge!(search_options)
    sphinx_options.merge!(sort_options)

    if options[:sSearch_1] == 'all' && !options[:sSearch].blank?
      condition_string = "@(name,actual_name,email,phone_number,company_name) #{options[:sSearch]}*"
      sphinx_options.merge!(:match_mode => :extended)
      User.search(condition_string, sphinx_options).page(page).per(options[:iDisplayLength])
    else
      sphinx_options.deep_merge!(:conditions => {options[:sSearch_1] => "#{options[:sSearch]}*"}) if !options[:sSearch_1].blank? and !options[:sSearch].blank? 
      User.search(query, sphinx_options).page(page).per(options[:iDisplayLength])
    end
  end

  def set_nest(channel_subscription)
    channel_subscription.user ||= self
  end

  def subscription_params
    ucs_attribs = self.user_channel_subscriptions.map(&:attributes).collect{|x| x.keep_if{|k, v| ["course_id", "channel_id"].include? k}}
    errors.add(:base, "User course subscription must be unique for a channel.") unless (ucs_attribs.uniq.length == ucs_attribs.length)
  end  

  def set_course_admin_role
    ucs_attribs = self.user_channel_subscriptions.map(&:attributes).collect{|x| x.keep_if{|k, v| ["permission_create"].include? k}}
    if ucs_attribs.include?({"permission_create"=>true})
      self.add_role(:course_admin) if !self.has_role?(:course_admin)
    else
      self.remove_role(:course_admin)
    end
  end

  def self.assign_role(user_id,role)
    user = User.find(user_id)
    user.add_role(role) if !user.has_role? role
  end

  def set_course_admin_user_id
    course_ids = self.user_channel_subscriptions.where(:permission_create => true).map(&:course_id)
    Course.set_course_admin_user_ids(course_ids, id)
  end

  def watchable_course? course_id
    self.subscribed_course_ids.include?(course_id)
  end

  def trial_course? course_id
    self.user_channel_subscriptions.where(:subscription_id => 1).pluck(:course_id).include? (course_id)
  end

  def watchable_video? video, video_course_id
    if self.trial_course?(video_course_id)
       video.demo || video.trial
    else
      self.subscribed_course_ids.include?(video_course_id) || video.demo
    end
  end
end