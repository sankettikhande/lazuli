json.aaData @courses do |course|
  json.name link_to(course.name, edit_admin_course_url(course))
  json.(course, :trainer_name, :channel_name, :user_count)
  json.actions course_actions(course)
end
json.sEcho params[:sEcho].to_i
json.iTotalRecords  @courses.total_entries
json.iTotalDisplayRecords @courses.total_entries
