class AddPaperclipVideoUploadInVideoTable < ActiveRecord::Migration
  def change
  	add_attachment :videos, :clip
  end
end
