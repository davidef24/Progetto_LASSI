class OrdersController < ApplicationController
  def index
    @user_for_orders = User.find(params[:user_id])
  end

  def show
    @order = Order.find(params[:id])
  end

  def success
    if params[:session_id].present? 
      @current_cart.decrease_quantity
      order = Order.create(user: @current_user, cart:@current_cart)
      order.save
      #after an order has completed, we create another cart
      session[:cart_id] = nil
    else
      redirect_to cancel_url, alert: "No info to display"
    end
  end

  def create
    line_items_json = @current_cart.cart_items.map do |item|
      { price: item.product.stripe_price_id, quantity: item.quantity}
    end

    puts line_items_json

    @session = Stripe::Checkout::Session.create({
        customer: @current_user.stripe_customer_id,
        payment_method_types: ['card'],
        line_items: line_items_json,
        mode: 'payment',
        success_url: payment_success_url + "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: payment_cancel_url,
    })
    payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
    redirect_to @session.url
  end
  
  private
    
end