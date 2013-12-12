module Admin::ContentsHelper

	def channel_name_for_topic(id)
	  channel = Channel.find_by_id(id)
	  channel_name = channel.name if channel
	end
end
