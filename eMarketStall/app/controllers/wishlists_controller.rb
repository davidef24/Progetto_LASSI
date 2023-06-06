class WishlistsController < ApplicationController
    before_action :check_if_deleted
    def show
        @wl_user=Wishlist.find_by(user_id: @current_user.id)
    end

    private 

    def check_if_deleted
        @wl_user=Wishlist.find_by(user_id: @current_user.id)
        @wl_user.wishlist_items.each do |item|
            if item.product.removed_from_seller
                item.destroy
                item.save
            end
        end
    end
end
