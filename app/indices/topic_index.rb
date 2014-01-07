ThinkingSphinx::Index.define :topic, :with => :active_record, :delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes title, :sortable => true
  indexes description
  has created_at, updated_at
end