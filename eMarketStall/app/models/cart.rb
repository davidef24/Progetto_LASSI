class Cart < ApplicationRecord
    has_many :cart_items, dependent: :destroy
    has_many :products, through: :cart_items

    #called after an order ha succeeded to update products availability
    def decrease_quantity
      self.cart_items.each do |cart_item|
        selected_quantity = cart_item.quantity
        cart_item.product.availability -= selected_quantity
        cart_item.product.save
      end
    end

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
