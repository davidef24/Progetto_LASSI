require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
    let(:user_1) { User.create(email: 'test.user@example.com', password: 'password', nome: 'Test', cognome: 'Bianchi', città: 'Padova', roles_mask: 1, cap_residenza: '37100', via_residenza: 'Via Bianchi, 3', num_telefono: '3211233344') }
    let(:user_2) { User.create(email: 'test2.user@example.com', password: 'password', nome: 'Test2', cognome: 'Rossi', città: 'Roma', roles_mask: 2, cap_residenza: '13425', via_residenza: 'Via Tizio, 3', num_telefono: '3211829344') }
    let(:product) { Product.create(user_id: user_1.id, title: 'Wood table', price: 30, category: 'Wood processing', description: 'Four seats table', availability: 3) }
    describe "GET #index" do
        it "assigns @product with the correct product" do
            puts "\nRunning test: assigns @product with the correct product"
            get :index, params: { product_id: product.id }
            expect(assigns(:product)).to eq(product)
        end
    end

    describe "GET #user_reviews" do
        it "assigns @user_reviews with the correct user" do
          puts "\nRunning test: assigns @user_reviews with the correct user"
          get :user_reviews, params: { user_id: user_1.id }
          expect(assigns(:user_reviews)).to eq(user_1)
        end
    end

    describe "POST #create" do
        context "with valid parameters" do
          # redirect to the order page beceause from there, User can update it or going into the seller's page and view it
          it "creates a new review, associates it with the product, and redirects to the orders page" do
            puts "\nRunning test: creates a new review, associates it with the product, and redirects to the orders page"
            review_attributes = { content: "Great product!", rating: 5, current_user_id: user_2.id }
            post :create, params: { product_id: product.id, review: review_attributes}
            review = Review.last
            expect(review.product).to eq(product)
            expect(response).to redirect_to(user_orders_path(user_2.id))
          end

          it "creates a new review visible in seller's reviews page" do
            puts "\nRunning test: creates a new review visible in seller's reviews page"
            review_attributes = { content: "Great product!", rating: 5, current_user_id: user_2.id }
            post :create, params: { product_id: product.id, review: review_attributes}
            #in this case seller of product reviewed is user_1
            expect(user_1.products.where(id: product.id).first.reviews).to include(Review.last)
            
          end
        end

        context "with invalid parameters" do
            it "does not create a new review and re-renders the 'new' template" do
              puts "\nRunning test: does not create a new review and re-renders the 'new' template"
              #rating can be a number in 1..5
              review_attributes = { content: "Great product!", rating: 15, current_user_id: user_2.id }
              post :create, params: { product_id: product.id, review: review_attributes }
              expect(Review.count).to eq(0)
              expect(response).to render_template(:new)
            end
        end
    end
end
