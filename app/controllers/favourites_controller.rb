class FavouritesController < SharedController
	def create
		fav_params = {:favouritable_type => params[:item_type], :favouritable_id => params[:item_id], :user_id => current_user.id}
		unless Favourite.create fav_params
			@alertClass = "danger"
			@msg = "#{params[:item_type]} can't be added to favourite list."
		end
	end

	def delete_favs
		favourite = Favourite.find(:last, :conditions => ["favouritable_type = ? and favouritable_id = ? and user_id = #{current_user.id}", params[:item_type], params[:item_id]])
		unless favourite.destroy
			@alertClass = "danger"
			@msg = "#{params[:item_type]} can't be remove from favourite list."
		end
		respond_to do |format|
			format.js {render '/favourites/destroy'}
		end
	end

	def remove
		if params[:favourites_ids]
			Favourite.where(:favouritable_id => params[:favourites_ids].keys, :favouritable_type => "Video", :user_id => current_user.id).destroy_all
			@videos = Favourite.get_user_videos(current_user)
		end
	end
end
