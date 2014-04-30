module Admin::SharedVideoLinksHelper
	def link(shared_video)
    url = course_topic_video_url(shared_video.course_id, shared_video.topic_id, shared_video.video_id, :token => shared_video.u_token) 
    link_to(url,url)
  end

  def link_actions shared_video
    link_to(link_raw_field('fa fa-ban'), admin_shared_video_link_path(shared_video), :rel=>'tooltip', :title => 'Delete Link', :class=>'btn-trans', :data =>{'no-turbolink'=>'true', :method => 'delete', :confirm => 'Are you sure you want to delete?'})
  end
end
