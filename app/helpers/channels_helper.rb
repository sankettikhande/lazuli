module ChannelsHelper
	def is_admin?
		current_user.has_role?(:admin) ? false : true
	end
end
