class RemoveProductslistFromWishlists < ActiveRecord::Migration[6.1]
  def change
    remove_column :wishlists, :productslist, :text
  end
end
