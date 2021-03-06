class ContactUsController < ApplicationController
	def create
		@contact_us = ContactUs.new(params[:contact_us]) 
		@contact_us.user_id=current_user.id if user_signed_in?	  
		@contact_us.email=current_user.email if user_signed_in?	   
	    respond_to do |format|
	      if @contact_us.save
	      	Emailer.delay(:queue => "mail_sender").sent_contact_us(@contact_us)
	        format.js
	        flash[:success] = "Your message has been sent successfully.!!!"
	      else       
	        format.js
	      end
	    end
	end
end
