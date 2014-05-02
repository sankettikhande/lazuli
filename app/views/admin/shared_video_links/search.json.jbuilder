json.aaData @user_share_videos do |user_share_video|
  json.video_title user_share_video.video_title
  json.email user_share_video.email.gsub(",", " ")
  json.ends_on user_share_video.ends_on
  json.no_of_views_remaining user_share_video.no_of_views_remaining
  json.link link(user_share_video)
  json.actions link_actions(user_share_video)
end
json.sEcho params[:sEcho].to_i
json.iTotalRecords  @user_share_videos.blank? ? 0 : @user_share_videos.total_entries
json.iTotalDisplayRecords @user_share_videos.blank? ? 0 : @user_share_videos.total_entries
