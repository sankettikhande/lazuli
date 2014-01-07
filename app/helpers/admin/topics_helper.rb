module Admin::TopicsHelper
	def set_video_accordance(title)
		title.present? ? title : "Add Video"
	end
end
