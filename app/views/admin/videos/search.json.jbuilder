json.aaData @videos do |video|
  json.title link_to(video.title, edit_admin_topic_url(video.topic))
  json.topic_name topic_name_with_edit_link(video.topic)
  json.course_name video.topic.course.name
  json.tags video.tag_list
  json.channel_name video.topic.channel.name
  json.vimeo_url link_to(video.vimeo_url, video.vimeo_url)
end
json.sEcho params[:sEcho].to_i
json.iTotalRecords  @videos.blank? ? 0 : @videos.total_entries
json.iTotalDisplayRecords @videos.blank? ? 0 : @videos.total_entries
