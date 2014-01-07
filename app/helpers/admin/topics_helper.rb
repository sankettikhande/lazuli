module Admin::TopicsHelper
	def video_title(title)
		title.present? ? title : "Add Video"
	end
end
