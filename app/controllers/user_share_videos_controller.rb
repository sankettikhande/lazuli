class UserShareVideosController < ApplicationController
	def create
		@user_share_video = UserShareVideo.new(params[:user_share_video])
		@user_share_video.user_id = current_user.id if user_signed_in?
		@user_share_video.starts_on = Date.today
		@user_share_video.ends_on = (Date.today + params[:user_share_video][:duration].to_i)
		token = ((0...4).map{ ('A'..'Z').to_a[rand(26)] } + (0...4).map{ ('a'..'z').to_a[rand(26)] } + (0...3).map{ (0..9).to_a[rand(9)] }).shuffle.join
		@user_share_video.u_token =  token
	    respond_to do |format|
	      if @user_share_video.save
	      	Emailer.delay(:queue => 'mail_sender').share_video(@user_share_video)
	        format.js
	        flash[:success] = "Your message has been sent successfully.!!!"
	      else       
	        format.js
	      end
	    end
		
	end

	def count_views
		@usv = UserShareVideo.find_by_u_token(params[:token])
		@usv.no_of_time_viewed += 1
		respond_to do |format|
			if @usv.save
				format.js
				flash[:success] = "Your have #{@usv.no_of_views_remaining} views remaining.!!!"
			else
				format.js
			end
		end
	end
end
