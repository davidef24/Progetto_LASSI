class OrdersController < ApplicationController
  def index
    @user_for_orders = User.find(params[:user_id])
  end

  def show
    @order = Order.find(params[:id])
  end

  def success
    if params[:session_id].present? 
      @session_with_expand = Stripe::Checkout::Session.retrieve({ id: params[:session_id], expand: ["line_items"]})
      @session_with_expand.line_items.data.each do |line_item|
        product = Product.find_by(stripe_product_id: line_item.price.product)
      end
    else
      redirect_to cancel_url, alert: "No info to display"
    end
  end

  def create
    @order = @current_cart.cart_items.first.order
    puts "-----PERFETTO, STO PER FARE IL CHECKOUT, VEDIAMO QUESTO CARRELLO A CHI È INTESTATO E COSA CONTINENE---------"
    @current_cart.cart_items.each do |item|
      @order.cart_items << item
    end
    @order.save
    puts "----------QUESTO CARRELLO È DI "+@order.user.email+" ----------------------------"
    @order.cart_items.each do |it|
      puts "--------Prod: "+it.product.title 
    end

    line_items_json = @current_cart.cart_items.map do |item|
      { price: item.product.stripe_price_id, quantity: item.quantity}
    end

    puts line_items_json

    @session = Stripe::Checkout::Session.create({
        customer: @current_user.stripe_customer_id,
        payment_method_types: ['card'],
        line_items: line_items_json,
        mode: 'payment',
        success_url: success_url_url + "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: cancel_url_url,
    })
    redirect_to @session.url
  end
  
  private
    
end