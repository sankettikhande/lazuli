ThinkingSphinx::Index.define :course, :with => :active_record, :delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes name, :as => :title, :sortable => true
  indexes description
  indexes course_trainers.name, :as => :trainer_name, :sortable => true
  indexes channel.name, :as => :channel_name, :sortable => true
  indexes channel.channel_type , :as => :channel_type, :sortable => true
  indexes course_admin_user_id, :as => :course_admin_user, :sortable => true
  indexes topics.title, :as => :topic_title
  indexes topics.status, :as => :status
  has created_at, updated_at, user_count
  has :id, :as => :course_id
  has course_admin_user_id
  has channel_admin_user_id
  has "1", :as => :custom_model_sort, :type => :integer
end