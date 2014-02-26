class Course < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :description, :trainer_name, :trainer_biography, :image, :channel_id,
                  :channel_course_permissions_attributes, 
                  :course_subscriptions_attributes, :subscription_ids

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, 
                    :default_url => ":class/:style/missing.gif", 
                    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
                    :url => "/system/:class/:attachment/:id/:style/:basename.:extension"

  #ASSOCIATIONS
  belongs_to :channel, :counter_cache => :course_count
  has_many :topics, :dependent => :destroy
  has_many :user_channel_subscriptions, :dependent => :destroy
  has_many :channel_course_permissions, :dependent => :destroy

  has_many :course_subscriptions, :dependent => :destroy
  has_many :subscriptions, :through => :course_subscriptions
  has_many :watch_lists, :dependent => :destroy

  include Cacheable
  #VALIDATIONS
  validates_lengths_from_database :limit => {:string => 255, :text => 1023}
  validates :image, :presence => true
  validates_presence_of :name, :message => "^Course Name can't be blank"
  validates_attachment_size :image, :less_than => 3.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png','image/gif','image/jpg']
  validate :course_name
  validate :course_subscription_params
  accepts_nested_attributes_for :channel_course_permissions, :allow_destroy => true
  accepts_nested_attributes_for :course_subscriptions, :reject_if => proc { |a| !a['subscription_id'].present? }, :allow_destroy => true
  #SCOPES
  after_save :set_channel_permission, :update_topics_sphinx_delta
  after_initialize :create_associations
  before_update :update_course_admin_user_ids, :if => :course_admin_user_id_changed?
  after_create :set_channel_admin_user_ids

  def self.public_channel_courses limit_record
    Channel.public_channels.limit(10).map{|c| c.courses }.flatten.take(limit_record)
  end
  
  #INSTANCE METHODS
  def set_channel_permission
    self.channel_course_permissions.each do |permission|
      permission.channel_id = self.channel_id
      permission.save
    end
  end

  def course_subscription_params
    errors.add(:base, "Please select atleat one subscription.") if self.course_subscriptions.blank?
  end

  def course_admin_user
    self.course_admin_user_id ? User.find(self.course_admin_user_id).actual_name.titleize : ''
  end  

  def add_destroy_keys course_subscriptions_params
    course_subscriptions_params.each {|k, v| v.merge!(:_destroy => 1) unless v.has_key?("subscription_id")}
  end  

  def update_course_admin_user_ids
    self.topics.each do |topic|
      topic.update_attribute(:course_admin_user_id, course_admin_user_id)
      topic.videos.map{|v| v.update_attribute(:course_admin_user_id, course_admin_user_id)}
    end
  end

  def set_channel_admin_user_ids
    update_attribute(:channel_admin_user_id, channel.admin_user_id)
  end

  # updates topics indices and invoke method to update video indices
  def update_topics_sphinx_delta
    topics.each do |t|
      t.delta = true
      t.save
    end
  end

  def paypal_url(return_url, notify_url, options = {})
    values = {
      :business => 'rakesh.patri.123@gmail.com',
      :cmd => '_cart',
      :upload => 1,
      :return => return_url,
      :notify_url => notify_url,
      :invoice => rand(10000)
    }
    values.merge!({
      "amount_1" => self.course_first_subscription(options[:subscription_id]).subscription_price,
      "item_name_1" => "#{name} :#{Subscription.find_by_id(options[:subscription_id]).name}",
      "item_number_1" => id,
      "quantity_1" => '1'
    })
    "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
     # "https://www.paypal.com/cgi-bin/webscr?" + values.to_query
  end

  def channel_name
    channel.name if channel
  end

  def course_name
    c_courses = channel.courses.to_a rescue []
    return if c_courses.blank?
    c_courses.delete(self)
    channel_course_names = c_courses.map(&:name)
    errors.add(:base, "Course name must be unique.") if channel_course_names.include? self.name
  end

  def name_for_form
    name.blank? ? "Course Details" : name
  end

  def users_for_course
    user_channel_subscriptions.blank? ? "-" : user_channel_subscriptions.count
  end

  def self.sphinx_search options, current_user, course_ids=[]
    sort_options, search_options, sphinx_options,select_option = {}, {}, {}, {}
    options[:sSearch] = options[:sSearch].gsub(/([_@#!%()\-=;><,{}\~\[\]\.\/\?\"\*\^\$\+\-]+)/, ' ')

    if course_ids.blank?
      query = options[:sSearch].blank? ? "" : "#{options[:sSearch]}*"
      page = (options[:iDisplayStart].to_i/options[:iDisplayLength].to_i) + 1
      sort_options.merge!(:order => [options["mDataProp_#{options[:iSortCol_0]}"], options[:sSortDir_0]].join(" "))
      unless current_user.is_admin?
        with_permitted_user = "*,IF (channel_admin_user_id = #{current_user.id} OR course_admin_user_id =#{current_user.id},1,0) AS permitted_user"
        select_option.merge!(:select => with_permitted_user)
        search_options.merge!(:with => {"permitted_user" => 1})
      end
      sphinx_options.merge!(sort_options).merge!(select_option).merge!(search_options)

      if options[:sSearch_1] == 'all' && !options[:sSearch].blank?
        condition_string = "@(name,channel_name,trainer_name) #{options[:sSearch]}*"
        sphinx_options.merge!(:match_mode => :extended)
        Course.search(condition_string,sphinx_options ).page(page).per(options[:iDisplayLength])
      else
        sphinx_options.deep_merge!(:conditions => {options[:sSearch_1] => "#{options[:sSearch]}*"}) if !options[:sSearch_1].blank? and !options[:sSearch].blank? 
        Course.search(query, sphinx_options).page(page).per(options[:iDisplayLength])
      end

    else
      search_options.deep_merge!(:with => {:course_id => course_ids})
      options[:sSearch].blank? ? sphinx_options.merge!(search_options).deep_merge!(:include => [:course, :channel])  : sphinx_options.merge!(search_options).deep_merge!(:conditions => {options[:sSearch_1] => "#{options[:sSearch]}*"}, :include => [:course, :channel]) 
      Course.search(sphinx_options)
    end
  end

  def self.set_course_admin_user_ids(course_ids,user_id)
    Course.where(:id => course_ids).map { |c| c.update_attribute(:course_admin_user_id, user_id) if c.course_admin_user_id.blank?  } 
  end

  def course_first_video
    self.topics.published.includes(:videos).each do |topic|
      @course_videos = topic.videos.published
    end
    return @course_videos.demo_videos.first || @course_videos.first if @course_videos.present?
  end

  def course_first_subscription subscription_id
    CourseSubscription.where(:subscription_id => subscription_id, :course_id => self.id).first
  end

  private 
  def create_associations()
    self.channel_course_permissions.build if self.new_record? && self.channel_course_permissions.size.zero?
  end
end
