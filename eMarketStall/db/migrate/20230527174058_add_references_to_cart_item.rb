class AddReferencesToCartItem < ActiveRecord::Migration[6.1]
  def change
    add_reference :cart_items, :product, null: false, foreign_key: true
  end
end
