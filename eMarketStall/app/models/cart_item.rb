class CartItem < ApplicationRecord
    belongs_to :product
    belongs_to :cart

    validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

    def total_price
        self.quantity * self.product.price
    end
end
