json.aaData @topics do |topic|
  json.title link_to(topic.title, edit_admin_topic_url(topic))
  json.course_name topic.course.name
  json.channel_name topic.channel.name
  json.vimeo_url topic.vimeo_album_url
  json.actions topic_actions(topic)
end
json.sEcho params[:sEcho].to_i
json.iTotalRecords  @topics.total_entries
json.iTotalDisplayRecords @topics.total_entries