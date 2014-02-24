class UserReviewsController < ApplicationController
	def create
		@user_review = UserReview.new(params[:user_review]) 
		@user_review.user_id=current_user.id if user_signed_in?	   
	    respond_to do |format|
	      if @user_review.save
	        format.js
	        flash[:success] = "Your review is saved. Thanks !!!"
	      else       
	        format.js
	      end
	    end
	end
end
