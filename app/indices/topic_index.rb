ThinkingSphinx::Index.define :topic, :with => :active_record, :delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes title, :sortable => true
  indexes course.name , :as => :course_name, :sortable => true
  indexes channel.name, :as => :channel_name , :sortable => true
  indexes vimeo_album_id , :as => :vimeo_url
  indexes description
  has created_at, updated_at
  has channel_id
  has course_id
end