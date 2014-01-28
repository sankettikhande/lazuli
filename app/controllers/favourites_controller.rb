class FavouritesController < ApplicationController
	def index
	end

	def create
		fav_params = {:favouritable_type => params[:item_type], :favouritable_id => params[:item_id], :user_id => current_user.id}
		if Favourite.exists?(fav_params)
			@alertClass = "info"
			@msg = "#{params[:item_type]} already exists in favourite list."
		else
			begin
	  		Favourite.create fav_params
	  		@alertClass = "success"
	  		@msg = "#{params[:item_type]} added to favourite list."
	  	rescue Exception => e
	  		@alertClass = "danger"
	  		@msg = "#{params[:item_type]} can't be added to favourite list."
	  	end
	  end
		respond_to do |format|
      format.js
    end		
	end
end
