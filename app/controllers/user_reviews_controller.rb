class UserReviewsController < ApplicationController
	def create
		@user_review = UserReview.new(params[:user_review]) 
		@user_review.user_id=current_user.id if user_signed_in?	
		@contact_us.email=current_user.email if user_signed_in?	      
	    respond_to do |format|
	      if @user_review.save
	        format.js
	        flash[:success] = "Your Review has been sent successfully.!!!"
	      else       
	        format.js
	      end
	    end
	end
end
