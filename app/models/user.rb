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
  validates_presence_of :actual_name
  validates_presence_of :name, :message => "^User name can't be blank"
  validate :subscription_params
  include Cacheable

  accepts_nested_attributes_for :user_channel_subscriptions, :reject_if => :all_blank, :allow_destroy => true

  after_create :add_user_role
  after_save :set_channel_admin_role

  def confirm_status
    self.confirmed_at.blank? ? 'Awaiting confirmation' : 'Confirmed'
  end

  
  def add_user_role
    add_role(:user) if roles.blank?
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
    hash = {"User Name" => "name", "Actual Name" => "actual_name", "Password" => "password","Email" => "email", "Phone Number" => "phone_number", "Address" => "address"}
    header.collect {|h| hash[h]}
  end

  def self.import_users(user, admin_user_id)
    user_channel = user[:user_channel_subscriptions_attributes]
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
      errors.push("Invalid file type: #{bulksheet.original_filename}. File format should be '.xls' or '.xlsx'.") if !(file_extension == ".xls" || file_extension == ".xlsx")
    end
    errors
  end

  def self.sphinx_search options
    query = options[:sSearch].blank? ? "" : "#{options[:sSearch]}*"
    page = (options[:iDisplayStart].to_i/options[:iDisplayLength].to_i) + 1
    sort_options = [options["mDataProp_#{options[:iSortCol_0]}"], options[:sSortDir_0]].join(" ")
    User.search(query, :order => sort_options).page(page).per(options[:iDisplayLength])
  end

  def set_nest(channel_subscription)
    channel_subscription.user ||= self
  end

  def subscription_params
    ucs_attribs = self.user_channel_subscriptions.map(&:attributes).collect{|x| x.keep_if{|k, v| ["course_id", "channel_id"].include? k}}
    errors.add(:base, "User course subscription must be unique for a channel.") unless (ucs_attribs.uniq.length == ucs_attribs.length)
  end  

  def skip_confirmation!
    self.confirmed_at = Time.now.utc
  end

  def set_channel_admin_role
    ucs_attribs = self.user_channel_subscriptions.map(&:attributes).collect{|x| x.keep_if{|k, v| ["permission_create"].include? k}}
    if ucs_attribs.include?({"permission_create"=>true})
      self.add_role(:channel_admin) if !self.has_role?(:channel_admin)
    else
      self.remove_role(:channel_admin)
    end
  end

end