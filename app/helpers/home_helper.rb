module HomeHelper
	def is_active_videos index
		index.zero? ? "active" : nil
	end

	def video_thumbnail_image(video, options={})
    unless(video.thumbnail_control == true)
  		if video.vimeo_data
        if options.blank?
          video.get_best_thumbnail
        elsif options[:medium]
          video.get_best_thumbnail(1)
        elsif options[:small]
          video.get_best_thumbnail(0)
        end
      end
    else
      video.image.present? ? video.image.url : "process-thumb.png"
    end
  end

  def course_thumbnail_image(course, options={})
    if course.image.present?
      course.image.url(options[:image_size])
    else
      'no_logo.png'
    end
  end

  def channel_thumbnail_image(channel, options={})
    channel.image.present? ? channel.image.url(options[:image_size]) : 'no_logo.png'
  end
end
