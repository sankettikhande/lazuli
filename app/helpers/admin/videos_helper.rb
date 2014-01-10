module Admin::VideosHelper
	def channel_name_for_topic(id)
		channel = Channel.cached_find(id)
	  channel_name = channel.name if channel
	end

	def video_actions(video)
    action_str = "<a href='/admin/videos/#{video.id}/edit' class='btn-trans' rel='tooltip' title='Edit Video'><i class='fa fa-edit'></i></a>"
    action_str << "<a href='/admin/videos/#{video.id}' class='btn-trans' data-method='delete' data-confirm='Are you sure you want to delete?' rel='tooltip' title='Delete Video'><i class='fa fa-ban'></i></a>"
    publish_str =  video.published? ? link_to(raw_field('fa fa-cloud-upload'), "#", :class => "btn-trans disabled", :rel=>"tooltip", :title=>"Already Publish Video" ) : link_to(raw_field('fa fa-cloud-upload'), upload_admin_video_path(video), :class => "btn-trans", :rel=>"tooltip", :title=>"Publish Video" )
    action_str << publish_str
    action_str.html_safe
  end
end
