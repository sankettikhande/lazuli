class AddFindUsToChannels < ActiveRecord::Migration
  def self.up
  	change_table :channels do |t|
	  t.string :website if !column_exists? :channels, :website
	  t.string :facebook_page if !column_exists? :channels, :facebook_page
	  t.string :twitter_page if !column_exists? :channels, :twitter_page
	end
  end
  def self.down
  	change_table :channels do |t|
	  t.remove :website if column_exists? :channels, :website
	  t.remove :facebook_page if column_exists? :channels, :facebook_page
	  t.remove :twitter_page if column_exists? :channels, :twitter_page
	end
  end
end
