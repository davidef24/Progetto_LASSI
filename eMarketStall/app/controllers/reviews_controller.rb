class ReviewsController < ApplicationController
    #index reviews of a product
    def index
      @product = Product.find(params[:product_id])
      @num_reviews = Review.where(product_id: @product.id).count
    end

    #index reviews of all products sold by a user
    def user_reviews
      @user_reviews = @user_email = User.find_by(id: params[:user_id])
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
        @review = Review.new(product_id: params[:product_id], user_id: params[:review][:current_user_id], content: params[:review][:content], rating: params[:review][:rating])
        if !@review.save
          flash[:error] = "Error in creating review"
          puts @review.errors.full_messages
        end
        @product= Product.where(id: params[:product_id]).first
        @product.reviews << @review
        @product.save
        #@current_user.reviews << @review
    
        respond_to do |format|
          if @review.save
            format.html { redirect_to user_orders_path(params[:review][:current_user_id]), notice: "Review was successfully created." }
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
            format.html { redirect_to user_orders_path(@current_user), alert: "There was a prooblem with the update of your review, please retry." }
            format.json { render json: @review.errors, status: :unprocessable_entity }
          end
        end
    end
  
     private

     def review_params
       params.require(:review).permit(:rating, :content, :current_user_id)
     end
          
      
  end
  