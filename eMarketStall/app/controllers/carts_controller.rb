class CartsController < ApplicationController
  
  def show
    @cart = @current_cart
  end


  #destroying a cart, in our app means that session[:cart_id] has to be set up to nil
  #this will trigger in ApplicationController (method set_current_cart:line 14) the creation of a new cart, which initially will be empty
  def destroy
    session[:cart_id] = nil
    redirect_to cart_path(@current_cart)
  end
end
