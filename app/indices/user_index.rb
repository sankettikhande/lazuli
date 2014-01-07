ThinkingSphinx::Index.define :user, :with => :active_record, :delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes name, :sortable => true
  indexes email, :sortable => true
  indexes actual_name, :sortable => true
  has created_at, updated_at
end