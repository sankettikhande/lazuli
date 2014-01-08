class Channel < ActiveRecord::Base
  attr_accessible :name, :contact_number, :email, :user_name, :channel_type, :company_name, :company_contact_name, :company_postal_address, :company_address, :company_description, :company_number, :admin_user_id, :created_by, :image, :courses_attributes
  # attr_accessible :courses_attributes

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, 
                  :default_url => ":class/:style/missing.gif", 
                  :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
                  :url => "/system/:class/:attachment/:id/:style/:basename.:extension"

  #ASSOCIATIONS
  has_many :channel_courses, :dependent => :destroy
  has_many :courses, :through => :channel_courses
  has_many :channel_course_permissions, :dependent => :destroy
  has_many :user_channel_subscriptions, :dependent => :destroy

  include Cacheable
  
  belongs_to :admin, :class_name => User, :foreign_key => :admin_user_id
  belongs_to :creator, :class_name => User, :foreign_key => :created_by

  #VALIDATIONS
  validates :name, :company_name, :company_number, :email, :presence => true
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, :unless => Proc.new {|c| c.email.blank?}
  validates :admin_user_id, :presence => {:message => "actual name can't be blank."}
  validates_attachment_size :image, :less_than => 3.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png','image/gif','image/jpg']

  accepts_nested_attributes_for :courses, :reject_if => :all_blank, :allow_destroy => true

  #SCOPES
  after_save :set_channel_permission, :on => :create
  after_destroy :remove_course_associations


  #INSTANCE METHODS
  def subscription_types
    Subscription.all.map(&:name).join(", ")
  end

  #CLASS METHODS
  def set_channel_permission
    self.courses.each do |course|
      course.channel_course_permissions.each do |permission|
        permission.channel_id = self.id
        permission.save
      end
    end
  end

  def remove_course_associations
    self.courses.each do |course|
      course.destroy
    end
  end

  def users_for_channel
    user_channel_subscriptions.blank? ? "-" : user_channel_subscriptions.count
  end

  def self.sphinx_search options
    query = options[:sSearch].blank? ? "" : "#{options[:sSearch]}*"
    page = (options[:iDisplayStart].to_i/options[:iDisplayLength].to_i) + 1
    sort_options = [options["mDataProp_#{options[:iSortCol_0]}"], options[:sSortDir_0]].join(" ")
    Channel.search(query, :order => sort_options).page(page).per(options[:iDisplayLength])
  end
end
