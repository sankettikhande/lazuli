module AdminHelper
	def set_selected(current_controller)
    (current_controller == controller_name) ? "active" : ""  
	end
end
