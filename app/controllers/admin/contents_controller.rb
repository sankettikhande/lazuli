class Admin::ContentsController < AdminController
	def index
		respond_to do |format|
      format.html { }
    end
	end

	def get_topics
		respond_to do |format|
      format.js { }
    end
	end

	def get_videos
		respond_to do |format|
      format.js { }
    end
	end

	def get_courses
		respond_to do |format|
      format.js { }
    end
	end
end
