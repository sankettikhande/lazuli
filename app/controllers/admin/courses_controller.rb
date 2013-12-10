class Admin::CoursesController < AdminController

	def new
		@course = Course.new
		@channels = Channel.all
		@course.channel_courses.build
		@course.channel_course_permissions.build
	end

	def create
		@course = Course.new(params[:course])
		respond_to do |format|
			if @course.save
				format.html {redirect_to "#{admin_contents_url}#courses"}
			else
				@channels = Channel.all
				format.html {render "new"}
			end
		end
	end

	def edit
		@channels = Channel.all
		@course = Course.find_by_id(params[:id])
	end

	def update
		@course = Course.find_by_id(params[:id])
		respond_to do |format|
			if @course.update_attributes(params[:course])
				format.html {redirect_to "#{admin_contents_url}#courses"}
			else
				@channels = Channel.all
				format.html {render "edit"}
			end
		end
	end

	def destroy
		@course = Course.find_by_id(params[:id])
		@course.destroy
		respond_to do |format|
			format.html {redirect_to "#{admin_contents_url}#courses"}
		end
	end
end
