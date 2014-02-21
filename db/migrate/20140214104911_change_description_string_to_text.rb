class ChangeDescriptionStringToText < ActiveRecord::Migration
  def change
  	change_column :courses, :description, :text
  	change_column :videos, :description, :text
  	change_column :channels, :company_description, :text
  end
end
