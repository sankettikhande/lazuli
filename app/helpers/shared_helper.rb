module SharedHelper
	def shared_active?(name)
		"active" if name == controller_name
	end
end
