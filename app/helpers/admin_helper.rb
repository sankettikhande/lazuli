module AdminHelper
	def set_selected(current_controller)
		if current_controller.class == Array
			current_controller.include?(controller_name) ? "active" : ""
		else
			(current_controller == controller_name) ? "active" : ""
    end
	end
end
