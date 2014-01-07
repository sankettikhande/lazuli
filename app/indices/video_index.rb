ThinkingSphinx::Index.define :video, :with => :active_record, :delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes title, :sortable => true
  indexes description
  indexes summary
  has created_at, updated_at
end