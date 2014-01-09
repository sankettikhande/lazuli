json.aaData @videos do |video|
  json.title link_to(video.title, edit_admin_topic_url(video.topic))
  json.topic_name video.topic.title
  json.course_name video.topic.course.name
  json.tags video.tag_list
  json.channel_name video.topic.channel.name
  json.vimeo_url video.vimeo_url
  json.actions video_actions(video)
end
json.sEcho params[:sEcho].to_i
json.iTotalRecords  @videos.total_entries
json.iTotalDisplayRecords @videos.total_entries
