ThinkingSphinx::Index.define :course, :with => :active_record, :delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes name, :sortable => true
  indexes description
  has created_at, updated_at
end
