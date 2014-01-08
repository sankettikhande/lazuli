class Admin::CoursesController < AdminController

	before_filter :set_initialization, :only => [:new, :edit, :create, :update]

	def search
		@courses = Course.sphinx_search params
	end

	def new
		@course = Course.new
		@channels = Channel.all
		@course.channel_courses.build
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
		@course = Course.cached_find(params[:id])
	end

	def update
		@course = Course.cached_find(params[:id])
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
		@course = Course.cached_find(params[:id])
		@course.destroy
		respond_to do |format|
			format.html {redirect_to "#{admin_contents_url}#courses"}
		end
	end

	def get_channel_info
		@course = Course.find(params[:id], :include => :channels)
		respond_to do |format|
			format.json{}
		end
	end

	def course_subscription_types
		course = Course.find(params[:id], :include => :subscriptions)
		@course_subscriptions = course.subscriptions
		respond_to do |format|
			format.js
		end
	end

	private
  def set_initialization
    @subscriptions = Subscription.all
  end

end
