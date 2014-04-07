ThinkingSphinx::Index.define :favourite, :with => :active_record, :delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes title, :sortable => true
  indexes user_id
  has created_at, updated_at
  has :favouritable_id, :as => :video_id
  has id
end