module Admin::ContentsHelper

	def channel_name_for_topic(id)
		if id
		  channel = Channel.cached_find(id)
		  channel_name = channel.name if channel
		end
	end
end
