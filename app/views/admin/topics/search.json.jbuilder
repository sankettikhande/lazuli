json.aaData @topics do |topic|
  json.title topic.title
  json.course_name topic.course.name
  json.channel_name topic.channel.name
  json.vimeo_url "https://vimeo.com/album/#{topic.vimeo_album_id}"
  json.actions topic_actions(topic)
end
json.sEcho params[:sEcho].to_i
json.iTotalRecords  @topics.total_entries
json.iTotalDisplayRecords @topics.total_entries