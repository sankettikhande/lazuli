json.aaData @channels do |channel|
  json.name link_to(channel.name, edit_admin_channel_url(channel))
  json.channel_admin_user channel.channel_admin_user
  json.channel_type channel.channel_type.capitalize
  json.(channel, :course_count, :user_count)
  json.actions channel_actions(channel)
end
json.sEcho params[:sEcho].to_i
json.iTotalRecords  @channels.blank? ? 0 : @channels.total_entries
json.iTotalDisplayRecords @channels.blank? ? 0 : @channels.total_entries
