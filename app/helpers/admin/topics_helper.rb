module Admin::TopicsHelper
	def set_title_for_video(title)
		title.present? ? title : "Add Video"
	end
end
