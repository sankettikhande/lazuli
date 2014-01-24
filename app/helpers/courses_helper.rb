module CoursesHelper
	def vimeo_iframe_url
		if @video && @video.vimeo_id
			"//player.vimeo.com/video/#{@video.vimeo_id}"
		else
			"//player.vimeo.com/video/#{@course.topics.first.videos.first.vimeo_id}" if @course.topics.any?
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
		"in" if((@video && @video.topic.id == topic.id) || topic_index.zero? )
	end

	def is_active_video video
		'active' if (@video && @video.id == video.id)
	end
end
