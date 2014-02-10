class FavouritesController < SharedController

	def index
		@favourite_videos = Favourite.get_videos_for(current_user)
	end

	def create
		fav_params = {:favouritable_type => params[:item_type], :favouritable_id => params[:item_id], :user_id => current_user.id}
		unless Favourite.create fav_params
			@alertClass = "danger"
			@msg = "#{params[:item_type]} can't be added to favourite list."
		end
	end

	def destroy
		favourite = Favourite.find(:last, :conditions => ["favouritable_type = ? and favouritable_id = ? and user_id = #{current_user.id}", params[:item_type], params[:item_id]])
		unless favourite.destroy
			@alertClass = "danger"
			@msg = "#{params[:item_type]} can't be remove from favourite list."
		end
	end
end
