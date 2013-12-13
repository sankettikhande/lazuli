class User < ActiveRecord::Base
  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid , :name, :phone_number, :company_name, :address, :actual_name
  attr_accessible :user_channel_subscriptions_attributes
  has_many :user_channel_subscriptions, :dependent => :destroy
  has_many :subscriptions, :through => :user_channel_subscriptions
  validates_presence_of :name, :actual_name
 
  include Cacheable

  accepts_nested_attributes_for :user_channel_subscriptions, :reject_if => :all_blank, :allow_destroy => true


  def self.find_for_oauth(oauth_raw_data, oauth_user_data, signed_in_resource=nil )
    return User.where("(provider = '#{oauth_raw_data.provider}' AND uid = '#{oauth_raw_data.uid}') OR email='#{oauth_user_data.email}'").first || User.create!(name:oauth_user_data.name,
                            actual_name:oauth_user_data.name,
                            provider:oauth_raw_data.provider,
                            uid:oauth_raw_data.uid,
                            email:oauth_user_data.email,
                            password:Devise.friendly_token[0,20],
                          )
  end

  def self.import_users(user)
    user_channel = user[:user_channel_subscriptions_attributes]
    file =  user[:file]
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    user_array = []
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user = User.new((row.to_hash.slice(*accessible_attributes)).merge(:company_name => user[:company_name]))
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
    #VALIDATIONS HERE
    if bulksheet.blank?
      errors.push("Please upload an Excel file.") 
    else
      file_extension = File.extname(bulksheet.original_filename)
      errors.push("Invalid file type: #{bulksheet.original_filename}. File format should be '.xls' or '.xlsx'.") if !(file_extension == ".xls" || file_extension == ".xlsx")
    end
    errors
  end

end