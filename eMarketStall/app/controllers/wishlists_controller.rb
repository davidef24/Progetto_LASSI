class WishlistsController < ApplicationController
    
    def show
        @wl_user=Wishlist.find_by(user_id: @current_user.id)
    end
end
