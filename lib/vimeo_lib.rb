module VimeoLib

	class << self
		def album
			album = Vimeo::Advanced::Album.new(Settings.vimeo_app.consumer_key, Settings.vimeo_app.consumer_secret, :token => Settings.vimeo_app.token, :secret => Settings.vimeo_app.secret)		
		end

		def video
			video = Vimeo::Advanced::Video.new(Settings.vimeo_app.consumer_key, Settings.vimeo_app.consumer_secret, :token => Settings.vimeo_app.token, :secret => Settings.vimeo_app.secret)
		end

		def upload
			upload = Vimeo::Advanced::Upload.new(Settings.vimeo_app.consumer_key, Settings.vimeo_app.consumer_secret, :token => Settings.vimeo_app.token, :secret => Settings.vimeo_app.secret)	
		end

		def video_embed
			video_embed = Vimeo::Advanced::VideoEmbed.new(Settings.vimeo_app.consumer_key, Settings.vimeo_app.consumer_secret, :token => Settings.vimeo_app.token, :secret => Settings.vimeo_app.secret)	
		end

	end

end