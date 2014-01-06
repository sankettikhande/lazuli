json.set! :data do
	json.id @channel.id
	json.channel_type @channel.channel_type.titleize
end