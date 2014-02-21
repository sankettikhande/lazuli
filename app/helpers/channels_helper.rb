module ChannelsHelper
	def add_image_title(objekt)
		objekt.image.present? ? "Change Image" : "Add Image"
	end
end
