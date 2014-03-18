ThinkingSphinx::Index.define :contact_us, :with => :active_record,:delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes name, :sortable => true
  indexes subject, :sortable => true
  indexes email, :sortable => true
  indexes message
  has created_at, updated_at 
  has user_id
end