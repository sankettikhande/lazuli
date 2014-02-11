module HomeHelper
	def is_active_videos index
		index.zero? ? "active" : nil
	end

	def video_thumbnail_image(video, options={})
		if video.vimeo_data
      if options.blank?
        video.get_best_thumbnail
      elsif options[:medium]
        video.get_best_thumbnail(1)
      else
        video.get_best_thumbnail(0)
      end
    else
     video.image.present? ? video.image.url : "http://b.vimeocdn.com/thumbnails/defaults/default.480x640.jpg"
    end
  end

  def course_thumbnail_image(course, options={})
    if course.image.present?
      if options.blank?
        course.image.url
      elsif options[:medium]
        course.image.url(:medium)
      else
        course.image.url(:thumb)
      end
    else
      "http://b.vimeocdn.com/thumbnails/defaults/default.480x640.jpg"
    end
  end
end
