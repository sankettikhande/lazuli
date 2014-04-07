ThinkingSphinx::Index.define :watch_list, :with => :active_record, :delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes title, :sortable => true
  indexes user_id
  has created_at, updated_at
  has video_id
  has id
end