ThinkingSphinx::Index.define :video, :with => :active_record, :delta => ThinkingSphinx::Deltas::DelayedDelta do
  indexes title, :sortable => true
  indexes topic.title, :as => :topic_name, :sortable => true
  indexes topic.course.name, :as => :course_name, :sortable => true 
  indexes topic.channel.name,  :as => :channel_name, :sortable => true
  indexes description
  indexes summary
  indexes taggings.tag.name, :as => :tags
  has created_at, updated_at
end