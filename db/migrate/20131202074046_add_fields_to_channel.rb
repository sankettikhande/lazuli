class AddFieldsToChannel < ActiveRecord::Migration
  def self.up
    change_table :channels do |t|
		  t.string :contact_number if !column_exists? :channels, :contact_number
		  t.string :email if !column_exists? :channels, :email
		  t.string :user_name if !column_exists? :channels, :user_name
		  t.string :channel_type if !column_exists? :channels, :channel_type
		  t.string :company_name if !column_exists? :channels, :company_name
		  t.string :company_contact_number if !column_exists? :channels, :company_contact_number
		  t.string :company_address if !column_exists? :channels, :company_address
		  t.string :company_description if !column_exists? :channels, :company_description
		  t.string :company_number if !column_exists? :channels, :company_number
		end
  end

  def self.down
    change_table :channels do |t|
		  t.remove :contact_number if column_exists? :channels, :contact_number
		  t.remove :email if column_exists? :channels, :email
		  t.remove :user_name if column_exists? :channels, :user_name
		  t.remove :channel_type if column_exists? :channels, :channel_type
		  t.remove :company_name if column_exists? :channels, :company_name
		  t.remove :company_contact_number if column_exists? :channels, :company_contact_number
		  t.remove :company_address if column_exists? :channels, :company_address
		  t.remove :company_description if column_exists? :channels, :company_description
		  t.remove :company_number if column_exists? :channels, :company_number
		end 
  end
end
