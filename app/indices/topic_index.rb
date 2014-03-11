ThinkingSphinx::Index.define :topic, :with => :active_record, :delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes title, :sortable => true
  indexes course.name , :as => :course_name, :sortable => true
  indexes channel.name, :as => :channel_name , :sortable => true
  indexes channel.channel_type, :as => :channel_type
  indexes vimeo_album_id , :as => :vimeo_url
  indexes description
  indexes status, :as => :status
  has created_at, updated_at
  has course_admin_user_id
  has channel_admin_user_id
  has :id, :as => :topic_id
  has "2", :as => :custom_model_sort, :type => :integer
end