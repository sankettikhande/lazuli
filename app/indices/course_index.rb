ThinkingSphinx::Index.define :course, :with => :active_record, :delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes name, :sortable => true
  indexes description
  indexes trainer_name, :sortable => true
  indexes channel.name, :as => :channel_name, :sortable => true
  indexes topics.title, :as => :topic_title
  indexes topics.status, :as => :topic_status
  has created_at, updated_at, user_count
  has :id, :as => :course_id
  has course_admin_user_id
  has channel_admin_user_id
end