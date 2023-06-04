class ApplicationController < ActionController::Base
    before_action :set_current_user, :set_current_cart
    before_action :check_wishlist

    rescue_from CanCan::AccessDenied do |exception|
        redirect_to root_path, :alert => exception.message
        end

    private
  
    def set_current_user
      @current_user = current_user
    end

    def check_wishlist
      if user_signed_in?
        if @current_user.wishlist.nil?
          @wl=Wishlist.create(user: @current_user)
          @current_user.wishlist=@wl
          @wl.save
        end
      end
    end
    
    #Create a new cart when a new session is started, or when
    #in our app a user clicks on empty cart, this triggers the setting of session[:cart_id] to nil which will be captured by this method
    #and a new cart will be created
    def set_current_cart
      if session[:cart_id] == nil
        @current_cart = Cart.create
        session[:cart_id] = @current_cart.id
      else
        cart = Cart.find_by(:id => session[:cart_id])
        @current_cart = cart
      end
      
    end

end
