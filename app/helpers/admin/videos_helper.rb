module Admin::VideosHelper
	def channel_name_for_topic(id)
		channel = Channel.cached_find(id)
	  channel_name = channel.name if channel
	end

	def video_actions(video)
    "<a href='/admin/videos/#{video.id}/edit' class='btn btn-trans' rel='tooltip' title='Edit Video'><i class='fa fa-edit'></i></a><a href='/admin/videos/#{video.id}' class='btn btn-trans' data-method='delete' data-confirm='Are you sure you want to delete?' rel='tooltip' title='Delete Video'><i class='fa fa-ban'></i></a><a href='/admin/videos/#{video.id}/upload' class='btn btn-trans' rel='tooltip' title='Publish Video'><i class='fa fa-cloud-upload'></i></a>".html_safe
  end
end
