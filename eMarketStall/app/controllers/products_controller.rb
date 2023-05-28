class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authorize_product, only: [:edit, :update, :destroy]

  # GET /products or /products.json
  def index
    @products = Product.all
    @searched_item=params[:search]
    @category=params[:category]
    @products=Product.where("title LIKE ?", "%#{@searched_item}%")
    if @category.present?
      @products=@products.where(category: @category)
    end
    if params[:sort]=="title"
      @products=Product.order(:title)
    elsif params[:sort]=="price"
      @products=Product.order(:price)
    elsif params[:sort]=="category"
      @products=Product.order(:category)
    end
  end

  # GET /products/1 or /products/1.json
  def show
    @user = current_user
    @product = Product.find(params[:id])
  end

  # GET /products/new
  def new
    @user = current_user
    @product = @user.products.build
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @user = current_user
    @product = @user.products.build(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    authorize! :update, @product
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    authorize! :destroy, @product
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:title, :description, :price, :category, :availability, :verified)
    end

    def authorize_product
      authorize! params[:action].to_sym, @product, @current_user
    end
    
end
