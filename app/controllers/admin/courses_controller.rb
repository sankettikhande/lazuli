class Admin::CoursesController < AdminController

	def new
		@course = Course.new	
	end

	def create
		@course = Course.new(params[:course])
		if @course.save 
			redirect_to "/admin/contents"
		else
			render "new"
		end
	end
end
