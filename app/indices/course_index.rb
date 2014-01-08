ThinkingSphinx::Index.define :course, :with => :active_record, :delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes name, :sortable => true
  indexes description
  indexes trainer_name, :sortable => true
  indexes channels.name, :as => :channel_name, :sortable => true
  has created_at, updated_at, user_count
end