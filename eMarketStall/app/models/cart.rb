class Cart < ApplicationRecord
    has_many :cart_items, dependent: :destroy
    has_many :products, through: :cart_items

    def sub_total
        sum = 0
          self.cart_items.each do |cart_el|
            if !cart_el.product.nil?
              sum+= cart_el.total_price
            end
              
          end
        return sum
    end
end
