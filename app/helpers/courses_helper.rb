module CoursesHelper
	def vimeo_iframe_url
		if params[:t].blank?
			"//player.vimeo.com/video/#{@video.vimeo_id}?api=1&amp;player_id=player_1"
		else
			"//player.vimeo.com/video/#{@video.vimeo_id}?api=1&amp;player_id=player_1#t=#{params[:t]}"
		end
	end

	def is_active topic, index
		if @video
			@video.topic.id == topic.id ? "active panel" : "panel"
		else
  		index.zero? ? "active panel" : "panel"
		end
	end

	def is_accordion topic, topic_index
		"in" if((@video && @video.topic.id == topic.id) || (!@video && topic_index.zero?) )
	end

	def is_active_video video
		'active' if (@video && @video.id == video.id)
	end

	def is_active_bookmark bookmark, index
		if @video
			@video.bookmarks[index].id == bookmark.id ? "active panel" : "panel"
		else
  		index.zero? ? "active panel" : "panel"
		end
	end


	def second_to_duration(seconds)
		Time.at(seconds).utc.strftime("%H:%M:%S")
	end

	def format_duration(video)
		video.vimeo_data ? second_to_duration(video.vimeo_data.duration.to_i) : "00:00:00"
	end

	def is_watch_listed(video_id, course_id)
		return WatchList.where(:video_id => video_id, :course_id => course_id, :user_id => current_user).any? ? "true" : "false"
	end

	def bookmark_time_format(time_str)
		arr = ["h","m","s"]
		str = ""
		time_str.split(":").each_with_index do |time, index|
			str << time.to_i.to_s << arr[index] unless time.to_i.zero?
		end
		"?t=" << str unless str.blank?
	end
end
