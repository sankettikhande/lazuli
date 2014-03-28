ThinkingSphinx::Index.define :contact_us, :with => :active_record,:delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes name, :sortable => true
  indexes subject, :sortable => true
  indexes email, :sortable => true
  indexes message
  indexes created_at, :as => :created_time, :sortable => true
  has created_at
  has updated_at 
  has user_id
end