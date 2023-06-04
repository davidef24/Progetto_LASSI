require 'rails_helper'

RSpec.describe CartItemsController, type: :controller do
    let(:user) { User.create(email: 'test.user@example.com', password: 'password', nome: 'Test', cognome: 'Bianchi', città: 'Padova') }
    let(:product) { Product.create(user_id: user.id, title: 'Tavolo', price: 30, category: 'Wood processing', description: 'Per 4 posti a sedere', availability: 3) }
    let(:product2) { Product.create(user_id: user.id, title: 'Collana', price: 30, category: 'Chains', description: 'Fatta a mano', availability: 2) }

    describe 'POST #create' do
        context 'when the product is already in the cart' do
          it 'increments the quantity of the existing cart item' do
            puts "\nRunning test: increments the quantity of the existing cart item"
            post :create, params: { product_id: product.id }
            expect {
              post :create, params: { product_id: product.id }
            }.to change { Cart.last.cart_items.find_by(product_id: product.id).quantity }.by(1)  
          end

          it 'displays an error message when the availability is reached' do
            puts "\nRunning test: displays an error message when the availability is reached"
            product.update(availability: 2)
            #given the fact that a new session has begun, a new cart has been created and so we need to add three times since the last cart was removed
            3.times do
              post :create, params: { product_id: product.id }
            end
            expect(flash[:notice]).to eq("It's not possible to add additional quantities of #{product.title}. The maximum availability has been reached.")
            expect(response).to redirect_to(cart_path(Cart.last.id))
          end
        end
    end

    describe 'PATCH #decrease_number' do
      it 'decrements the quantity of the cart item by 1' do
        puts "\nRunning test: decrements the quantity of the cart item by 1"
        #we add two times product to cart so that quantity is two, I found this way to set quantity since if I create manually a CartItem there is a 
        #problem with the cart which is being assigned to it. In fact after a patch, get, or post action, he will create a new cart since we create a new cart 
        #in every session
        2.times do
          post :create, params: { product_id: product.id }
        end
        cart_item = Cart.last.cart_items.last
        patch :decrease_number, params: { cart_item_id: cart_item.id }
        expect(cart_item.reload.quantity).to eq(1)
      end
    end

    describe 'DELETE #destroy' do  
      it 'destroys the cart item' do
        puts "\nRunning test: destroys the cart item"
        #we add to this session cart, two instances of the first product and one of the second product
        2.times do
          post :create, params: { product_id: product.id }
        end
        cart_item = Cart.last.cart_items.find_by(product_id: product.id)
        post :create, params: { product_id: product2.id }
        expect {
          delete :destroy, params: { cart_item_id: cart_item.id }
        }.to change { Cart.last.cart_items.count }.by(-1)
        expect(Cart.last.cart_items.find_by(product_id: product.id)).to be_nil
      end
    end
end
