module ChannelsHelper
	def add_image_title(objekt)
		objekt.image.present? ? "Change Logo" : "Add Logo"
	end
end
