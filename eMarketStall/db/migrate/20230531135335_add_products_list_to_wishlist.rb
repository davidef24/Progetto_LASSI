class AddProductsListToWishlist < ActiveRecord::Migration[6.1]
  def change
    add_column :wishlists, :productslist, :text
  end
end
