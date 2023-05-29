class ApplicationController < ActionController::Base
    before_action :set_current_user, :current_cart

    rescue_from CanCan::AccessDenied do |exception|
        redirect_to root_path, :alert => exception.message
        end

    private
  
    def set_current_user
      @current_user = current_user
    end
    def current_cart
      if session[:cart_id]
        cart = Cart.find_by(:id => session[:cart_id])
        if cart.present?
          @current_cart = cart
        else
          session[:cart_id] = nil
        end
      end

      if session[:cart_id] == nil
        @current_cart = Cart.create
        session[:cart_id] = @current_cart.id
      end
    end
end
