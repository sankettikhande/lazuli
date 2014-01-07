ThinkingSphinx::Index.define :channel, :with => :active_record, :delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes name, :sortable => true
  indexes email, :sortable => true
  indexes company_name, :sortable => true
  indexes company_address
  indexes company_description

  has created_at, updated_at
end