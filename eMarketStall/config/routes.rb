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

<<<<<<< HEAD
  post 'orders/create' => "orders#create", as: "orders_create"
  get 'order/success' => "orders#success", as: "success_url"
  get 'order/cancel' => "orders#cancel", as: "cancel_url"

  get 'carts/:id' => "carts#show", as: "cart"
  delete 'carts/:id' => "carts#destroy"

  post 'cart_items/:id/increment' => "cart_items#increment_number", as: "cart_item_increase"
  post 'cart_items/:id/decrease' => "cart_items#decrease_number", as: "cart_item_decrease"
  post 'cart_items' => "cart_items#create"
  get 'cart_items/:id' => "cart_items#show", as: "cart_item"
  delete 'cart_items/:id' => "cart_items#destroy"
  
=======
>>>>>>> 6da7182fb38ea4290333441bdc0839260f6bcce9
  #only: [] to generate just routes for products
  #users routes handled by devise
  resources :users, only: [] do
    resources :products
    get 'my_products', to: 'users#my_products'
  end

  resources :users, only: [] do
    resources :orders, only: [:index]
  end
  
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  } 

  devise_scope :user do  
    get 'my_profile', to: 'users/registrations#show', as: :my_profile
    get '/users/sign_out' => 'devise/sessions#destroy'  
    get 'edit_profile', to: 'users/registrations#edit_profile'
    patch 'update_profile', to: 'users/registrations#update_profile'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "products#index"
end