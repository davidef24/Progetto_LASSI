class ReviewsController < ApplicationController
    
    def index
      @pippo = Product.find(params[:product_id])
    end

    def user_reviews
      #user who wants to see reviews which relate to his products sold
      @u = @user_email = User.find_by(id: params[:user_id])
    end

    def show
        @review = Review.find(params[:id])
        @user_email = User.find_by(id: @review.user_id).email
    end

    def edit
      @review = Review.find(params[:id])
      @product = @review.product
    end

    def new
      @product = Product.find(params[:product_id])
      @review = Review.new
    end

    def create
        @review = Review.new(product_id: params[:product_id], user_id: @current_user.id, content: params[:review][:content], rating: params[:review][:rating])
        @review.save
        @product= Product.where(id: params[:product_id]).first
        @product.reviews << @review
        @product.save
        #@current_user.reviews << @review
    
        respond_to do |format|
          if @review.save
            format.html { redirect_to product_review_path(@product, @review), notice: "Review was successfully created." }
            format.json { render :show, status: :created, location: @review }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @review.errors, status: :unprocessable_entity }
          end
        end
      end

    def update
        @review = Review.find_by(id: params[:id])
        respond_to do |format|
          if @review.update(review_params)
            format.html { redirect_to user_orders_path(@current_user), notice: "Review was successfully updated." }
            format.json { render :show, status: :ok, location: @review }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @review.errors, status: :unprocessable_entity }
          end
        end
    end
  
     private

     def review_params
       params.require(:review).permit(:rating, :content)
     end
          
      
  end
  