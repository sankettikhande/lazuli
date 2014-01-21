module HomeHelper
	def is_active_videos index
		index.zero? ? "active" : nil
	end
end
