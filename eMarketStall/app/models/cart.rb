class Cart < ApplicationRecord
    has_many :cart_items, dependent: :destroy
    has_many :products, through: :cart_items

    #called after an order ha succeeded to update products availability
    def decrease_quantity
      puts "----------TRYNG TO DECREASE QUANTITY-----------------"
      self.cart_items.each do |cart_item|
        selected_quantity = cart_item.quantity
        puts "PRIMA LA DISPONIBILITÀ ERA"+ cart_item.product.availability.to_s
        cart_item.product.availability -= selected_quantity
        cart_item.product.save
        puts "DOPO LA DISPONIBILITÀ È"+ cart_item.product.availability.to_s
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
