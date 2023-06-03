class CartItemsController < ApplicationController

  def create
      # Find associated product and current cart
      added_product_id = params[:product_id]
      added_product = Product.find(added_product_id)

    
      #@current_cart from app controller
      # If cart already has this product then find the relevant cart_item and iterate quantity otherwise create a new cart_item for this product
      if @current_cart.cart_items.find_by(:product_id => added_product_id)
        # Find the cart_item with the chosen_product
        @cart_item = @current_cart.cart_items.find_by(:product_id => added_product_id)
        # Iterate the cart_item's quantity by one
        if (@cart_item.quantity + 1) > @cart_item.product.availability
          flash[:notice] = "It's not possible to add additional quantities of #{added_product.title}. The maximum availability has been reached."
          redirect_to cart_path(@current_cart)
          return
        end
        @cart_item.quantity += 1
      else
        @cart_item = CartItem.create(cart_id: @current_cart.id, product_id: added_product_id, quantity: 1)
      end
    
      # Save and redirect to cart show path
      if @cart_item.save
        redirect_to cart_path(@current_cart)
      else
        redirect_to products_path, alert: @cart_item.errors.full_messages.join(", ")
      end
  end
  def increment_number
      @cart_item = CartItem.find(params[:cart_item_id])
      if (@cart_item.quantity + 1) > @cart_item.product.availability
        flash[:notice] = "It's not possible to add additional quantities of #{@cart_item.product.title}. The maximum availability has been reached."
        redirect_to cart_path(@current_cart)
        return
      end
      @cart_item.quantity += 1
      @cart_item.save
      redirect_to cart_path(@current_cart)
  end
    
  def decrease_number
      @cart_item = CartItem.find(params[:cart_item_id])
      if @cart_item.quantity > 1
        @cart_item.quantity -= 1
      end
      @cart_item.save
      redirect_to cart_path(@current_cart)
  end

  def destroy
      @cart_item = CartItem.find(params[:cart_item_id])
      if @cart_item.destroy
        redirect_to cart_path(@current_cart)
      else 
        redirect_to products_path, alert: @cart_item.errors.full_messages.join(", ")
      end
  end  
    
  private
      def cart_item_params
        params.require(:cart_item).permit(:quantity,:product_id, :cart_id)
      end
end
