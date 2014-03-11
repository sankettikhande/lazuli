class Admin::CoursesController < AdminController

	before_filter :set_initialization, :only => [:new, :edit, :create, :update]
	load_and_authorize_resource
	
	def search
		@courses = Course.sphinx_search(params, current_user)
	end

	def new
		@course = Course.new
	end

	def create
		@course = Course.new(params[:course])
		@course.created_by = current_user.id
		respond_to do |format|
			if @course.save
				format.html {redirect_to "#{admin_contents_url}#courses" }
				flash[:success] = "Course has been successfully created"
			else
				format.html {render "new"}
			end
		end
	end

	def edit
		@course = Course.cached_find(params[:id])
	end

	def update
		@course = Course.cached_find(params[:id])
		@course.add_destroy_keys(params[:course][:course_subscriptions_attributes])
		respond_to do |format|
			if @course.update_attributes(params[:course])
				format.html {redirect_to "#{admin_contents_url}#courses"}
				flash[:success] = "Course has been successfully updated"
			else
				format.html {render "edit"}
			end
		end
	end

	def destroy
		@course = Course.cached_find(params[:id])
		@course.destroy
		Channel.reset_counters @course.channel.id, :courses
		respond_to do |format|
			format.html {redirect_to "#{admin_contents_url}#courses"}
		end
	end

	def get_channel_info
		@course = Course.cached_find(params[:id], :include => :channels)
		respond_to do |format|
			format.json{}
		end
	end

	def course_subscription_types
		@course = Course.cached_find(params[:id], :include => :subscriptions)
		@course_subscriptions = @course.subscriptions
		if params[:topic_course]
			@is_trial_subscription = @course_subscriptions.keep_if{|cs| cs.is_trial_subscription?}
		else
			@course_subscriptions.delete_if{|cs| cs.is_trial_subscription? && !@course.has_trial_videos?}
			@courses_permissions = @course.channel_course_permissions.first
		end
		respond_to do |format|
			format.js
		end
	end

	def course_videos
		@course = Course.cached_find(params[:id])
	end

	private
	def set_initialization
		administrated_channels = current_user.administrated_channels
		if current_user.is_admin?
			@channels = Channel.cached_all
		else
			if request.path.include? 'edit'
				course = Course.cached_find(params[:id])
				channel = course.channel
				@channels = administrated_channels.include?(channel) ? administrated_channels : [channel]	 
			else
				@channels = administrated_channels
			end
		end
		@subscriptions = Subscription.cached_all
	end

end
