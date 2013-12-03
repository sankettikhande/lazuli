class ChangeFieldsToChannel < ActiveRecord::Migration
  def change
  	add_column :channels, :company_contact_name, :string if !column_exists? :channels, :company_contact_name
  	add_column :channels, :company_postal_address, :string if !column_exists? :channels, :company_postal_address
  	remove_column :channels, :company_contact_number if column_exists? :channels, :company_contact_number
  end
end
