class ReviewsController < ApplicationController
    
    def index
        @p = Product.find(params[:product_id])
    end

    def show
        @p = Product.find(params[:product_id])
    end

    def edit

    end

    def new
        @product = Product.find(params[:product_id])
        @review = Review.new
    end

    def create
        @review = Review.new(review_params)
    
        @p= Produc.where(id: params[:product_id]).first
        @p.reviews << @review
        #@current_user.reviews << @review
    
        respond_to do |format|
          if @review.save
            format.html { redirect_to product_review_path(@p, @review), notice: "Review was successfully created." }
            format.json { render :show, status: :created, location: @review }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @review.errors, status: :unprocessable_entity }
          end
        end
      end

    def update
        respond_to do |format|
          if @review.update(review_params)
            format.html { redirect_to review_url(@review), notice: "Review was successfully updated." }
            format.json { render :show, status: :ok, location: @review }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @review.errors, status: :unprocessable_entity }
          end
        end
    end
  
    private
  
      # Only allow a list of trusted parameters through.
      def review_params
        params.require(:product).permit(:user_id, :product_id, :content, :rating)
      end
      
  end
  