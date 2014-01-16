json.aaData @courses do |course|
  json.name link_to(course.name, course_videos_admin_course_url(course), :remote => true)
  json.(course, :trainer_name, :channel_name, :user_count)
  json.actions course_actions(course)
end
json.sEcho params[:sEcho].to_i
json.iTotalRecords  @courses.total_entries
json.iTotalDisplayRecords @courses.total_entries