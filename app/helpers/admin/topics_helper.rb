module Admin::TopicsHelper
	def video_title(title)
		title.present? ? title : "Add Video"
	end

	def add_topic_title
		request.fullpath.include?("edit") ? "Edit Topic" : "Add Topic"
	end

	def topic_actions(topic)
		"<a href='/admin/topics/#{topic.id}/edit' class='btn-trans' data-no-turbolink='true' rel='tooltip' title='Edit Topic'><i class='fa fa-edit'></i></a><a href='/admin/topics/#{topic.id}' class='btn-trans' data-method='delete' data-confirm='Are you sure you want to delete?' rel='tooltip' title='Delete Topic'><i class='fa fa-ban'></i></a><a href='/admin/topics/#{topic.id}?Publish=Publish' class='btn-trans' data-method='put' rel='tooltip nofollow' title='Publish Topic'><i class='fa fa-cloud-upload'></i></a>".html_safe
	end
end
