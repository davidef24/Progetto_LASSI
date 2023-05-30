class AddRemovedFromSellerAndRemovedAtToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :removed_from_seller, :boolean, default: false
    add_column :products, :removed_at, :date
  end
end
