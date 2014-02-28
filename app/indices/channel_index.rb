ThinkingSphinx::Index.define :channel, :with => :active_record, :delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes name, :sortable => true
  indexes admin.name, :as => :channel_admin_user, :sortable => true
  indexes channel_type
  indexes courses.topics.status, :as => :topic_status
  has created_at, updated_at, user_count, course_count
  has :id, :as => :channel_id
end