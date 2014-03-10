ThinkingSphinx::Index.define :video, :with => :active_record, :delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes title, :sortable => true
  indexes topic.title, :as => :topic_name, :sortable => true
  indexes topic.course.name, :as => :course_name, :sortable => true 
  indexes topic.channel.name,  :as => :channel_name, :sortable => true
  indexes topic.channel.channel_type, :as=> :channel_type
  indexes description
  indexes summary
  indexes taggings.tag.name, :as => :tags
  indexes topic.course.id, :as => :course_id
  indexes topic.id, :as => :topic_id
  indexes status, :as => :status
  has created_at, updated_at
  has :id, :as => :video_id
  has course_admin_user_id
  has channel_admin_user_id
  has "3", :as => :custom_model_sort, :type => :integer
end