json.aaData @contact_us do |contact|
  json.(contact, :name, :email, :subject, :message)
end
json.sEcho params[:sEcho].to_i
json.iTotalRecords  @contact_us.blank? ? 0 : @contact_us.total_entries
json.iTotalDisplayRecords @contact_us.blank? ? 0 : @contact_us.total_entries
