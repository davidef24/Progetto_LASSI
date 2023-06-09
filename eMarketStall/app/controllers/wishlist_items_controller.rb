class WishlistItemsController < ApplicationController
    
    def add
        id=params[:id]
        added_product=Product.find_by(id: id)
        @wl_user=Wishlist.find_by(user_id: @current_user.id)
        already_added=false
        @wl_user.wishlist_items.each do |p|
            if p.product.id==added_product.id
                flash[:notice]="Product's already in wishlist"
                already_added=true
            end
        end
        if !already_added
            new_wishlist_item=WishlistItem.create(wishlist_id: @wl_user.id, product_id: added_product.id)
            new_wishlist_item.save
        end
        redirect_to show_wishlist_path(@wl_user)
    end

    def remove
        id=params[:id]
        to_be_removed=Product.find_by(id: id)
        @wl_user=Wishlist.find_by(user_id: @current_user.id)
        @wl_user.wishlist_items.each do |p|
            if p.product.id==to_be_removed.id
                p.destroy
                flash[:notice]="Product correctly removed from wishlist"
            end
        end
        redirect_to show_wishlist_path(@wl_user)
    end
end