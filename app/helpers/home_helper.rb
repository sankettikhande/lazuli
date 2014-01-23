module HomeHelper
	def is_active_videos index
		index.zero? ? "active" : nil
	end

	def video_thumbnail_image(video)
		if video.vimeo_data
      video.get_best_thumbnail
    else
     video.image.present? ? video.image.url : "http://b.vimeocdn.com/thumbnails/defaults/default.480x640.jpg"
    end
  end

  def course_thumbnail_image(course)
		course.image.present? ? course.image.url : "http://b.vimeocdn.com/thumbnails/defaults/default.480x640.jpg"
  end
end
