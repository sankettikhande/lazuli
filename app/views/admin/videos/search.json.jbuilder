json.aaData @videos do |video|
  json.title video.title
  json.topic video.topic.presence.try(:title)
  json.course video.topic.course.presence.try(:name)
  json.tags video.presence.try(:tag_list)
  json.channel_name video.topic.channel.name
  json.vimeo_url video.presence.try(:vimeo_url)
  json.actions video_actions(video)
end
json.sEcho params[:sEcho].to_i
json.iTotalRecords  @videos.total_entries
json.iTotalDisplayRecords @videos.total_entries
