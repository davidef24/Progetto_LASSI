Rails.application.routes.draw do
  get 'orders/index'
  get 'orders/show'
  get 'orders/new'
  get 'carts/show'
  resources :products do
    collection do
      get :search
    end
  end

  get 'wishlists/:id/add' => "wishlist_items#add", as: "add_to_wishlist"
  get 'wishlists/:id' => "wishlists#show", as: "show_wishlist"
  delete 'wishlist_items/:id' => "wishlist_items#remove", as: "remove_from_wishlist"

  post 'orders/create' => "orders#create", as: "orders_create"
  get 'orders/success' => "orders#success", as: "payment_success"
  get 'orders/cancel' => "orders#cancel", as: "payment_cancel"

  get 'carts/:cart_id' => "carts#show", as: "cart"
  delete 'carts/:cart_id' => "carts#destroy"

  post 'cart_items/:cart_item_id/increment' => "cart_items#increment_number", as: "cart_item_increase"
  post 'cart_items/:cart_item_id/decrease' => "cart_items#decrease_number", as: "cart_item_decrease"
  post 'cart_items' => "cart_items#create"
  get 'cart_items/:cart_item_id' => "cart_items#show", as: "cart_item"
  delete 'cart_items/:cart_item_id' => "cart_items#destroy"
  
  #only: [] to generate just routes for products
  #users routes handled by devise
  resources :users, only: [] do
    resources :products
    get 'my_products', to: 'users#my_products'
  end

  resources :products, only: [] do
    resources :reviews, except: :update
  end

  resources :users, only: [] do
    resources :orders, only: [:index]
  end
  
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  } 

  patch '/products/:product_id/reviews/:id', to: 'reviews#update', as: 'personalized_product_review'
  get '/user_reviews/:user_id', to: 'reviews#user_reviews', as: 'user_reviews'

  devise_scope :user do  
    get 'my_profile', to: 'users/registrations#show', as: :my_profile
    get '/users/sign_out' => 'devise/sessions#destroy'  
    get 'edit_profile', to: 'users/registrations#edit_profile'
    patch 'update_profile', to: 'users/registrations#update_profile'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "products#index"
end