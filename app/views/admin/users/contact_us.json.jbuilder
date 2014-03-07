json.aaData @contact_us do |contact|
  json.name contact.name
  json.email contact.email
  json.subject contact.subject
  json.message contact.message
end
json.sEcho params[:sEcho].to_i
json.iTotalRecords  @contact_us.blank? ? 0 : @contact_us.total_entries
json.iTotalDisplayRecords @contact_us.blank? ? 0 : @contact_us.total_entries
