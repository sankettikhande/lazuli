ThinkingSphinx::Index.define :user_share_video, :with => :active_record,:delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes video_title, :sortable => true
  indexes email, :sortable => true
  indexes ends_on, :sortable => true
  indexes user_id
  has created_at
  has updated_at
end