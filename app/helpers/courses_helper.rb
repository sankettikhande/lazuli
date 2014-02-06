module CoursesHelper
	def vimeo_iframe_url
		"//player.vimeo.com/video/#{@video.vimeo_id}?api=1&amp;player_id=player_1"
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

	def second_to_duration(seconds)
		Time.at(seconds).utc.strftime("%H:%M:%S")
	end

	def format_duration(vimeo_data)
		vimeo_data ? second_to_duration(vimeo_data.duration.to_i) : "00:00:00"
	end

	def video_play_url video, course, current_user
		if current_user.watchable_video? video, course.id
			course_videos_path(course.id, video.id)
		else
			root_url
		end
	end
end
