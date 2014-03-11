json.aaData @courses do |course|
  json.title link_to(course.name, course_videos_admin_course_url(course, :col => 'course_name'), :remote => true)
  json.(course, :courses_trainer_name, :channel_name, :course_admin_user, :user_count)
  json.actions course_actions(course)
end
json.sEcho params[:sEcho].to_i
json.iTotalRecords  @courses.blank? ? 0 : @courses.total_entries 
json.iTotalDisplayRecords @courses.blank? ? 0 : @courses.total_entries 