class AddProductIdToWishlistItems < ActiveRecord::Migration[6.1]
  def change
    add_reference :wishlist_items, :product, null: false, foreign_key: true
  end
end
