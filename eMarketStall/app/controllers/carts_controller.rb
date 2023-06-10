class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :checks_oauth
  def show
    @cart = @current_cart
  end


  #destroying a cart, in our app means that session[:cart_id] has to be set up to nil
  #this will trigger in ApplicationController (method set_current_cart:line 14) the creation of a new cart, which initially will be empty
  def destroy
    session[:cart_id] = nil
    redirect_to cart_path(@current_cart)
  end

  private

  def checks_oauth
    if @current_user.città.blank? || @current_user.cap_residenza.blank? || @current_user.via_residenza.blank? || @current_user.num_telefono.blank?
      redirect_to edit_profile_path
      flash[:alert] = "To complete a purchase, additional information beyond what is provided by your OAuth provider is required."
    end
  end
end
