class AddContactInfoToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
	  	t.string :phone_number if !column_exists? :users, :phone_number
	  	t.string :company_name if !column_exists? :users, :company_name
	  	t.string :address if !column_exists? :users, :address
	  end	
  end

  def self.down
  	change_table :users do |t|
	  	t.remove :phone_number if column_exists? :users, :phone_number
	  	t.remove :company_name if column_exists? :users, :company_name
	  	t.remove :address if column_exists? :users, :address
	  end	
  end	
end
