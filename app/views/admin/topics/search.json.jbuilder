json.aaData @topics do |topic|
  json.title link_to(topic.title, topic_videos_admin_topic_url(topic), :remote => true)
  json.course_name topic.course.name
  json.channel_name topic.channel.name
  json.vimeo_url topic_album_url(topic)
  json.actions topic_actions(topic)
end
json.sEcho params[:sEcho].to_i
json.iTotalRecords  @topics.blank? ? 0 : @topics.total_entries
json.iTotalDisplayRecords @topics.blank? ? 0 : @topics.total_entries