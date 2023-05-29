
class UsersController < ApplicationController
    def my_products
      @user = User.find(params[:user_id])
      @products = @user.products
    end
end
  