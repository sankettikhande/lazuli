module Admin::VideosHelper
	def channel_name_for_topic(id)
		channel = Channel.cached_find(id)
	  channel_name = channel.name if channel
	end

	def video_actions(video)
    action_str = "<a href='/admin/videos/#{video.id}/edit' class='btn-trans' rel='tooltip' title='Edit Video'><i class='fa fa-edit'></i></a>"
    action_str << "<a href='/admin/videos/#{video.id}' class='btn-trans' data-method='delete' data-confirm='Are you sure you want to delete?' rel='tooltip' title='Delete Video'><i class='fa fa-ban'></i></a>"
    action_str << publish_action(video)
    action_str.html_safe
  end

  def publish_action(video)
    if video.published?
      link_to(raw_field('fa fa-cloud-upload'), "#", :class => "btn-trans disabled", :rel=>"tooltip", :title=>"Video Already Published " )
    elsif video.inprocess?
      link_to(raw_field('fa fa-cloud-upload'), "#", :class => "btn-trans inprocess", :rel=>"tooltip", :title=>"Video Publishing InProcess" )
    else
      link_to(raw_field('fa fa-cloud-upload'), upload_admin_video_path(video), :class => "btn-trans", :rel=>"tooltip", :title=>"Publish Video" )
    end     
  end
end