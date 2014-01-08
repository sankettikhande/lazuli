json.aaData @channels do |channel|
  json.name link_to(channel.name, edit_admin_channel_url(channel))
  json.(channel, :channel_type, :course_count, :user_count, :subscription_types)
  json.actions channel_actions(channel)
end
json.sEcho params[:sEcho].to_i
json.iTotalRecords  @channels.total_entries
json.iTotalDisplayRecords @channels.total_entries
