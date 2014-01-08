ThinkingSphinx::Index.define :channel, :with => :active_record, :delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes name, :sortable => true
  has created_at, updated_at, user_count, course_count
end