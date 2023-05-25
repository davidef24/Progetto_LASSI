Rails.application.routes.draw do
  resources :products do
    collection do
      get :search
    end
  end
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  
  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'  
    get 'edit_profile', to: 'users/registrations#edit_profile'
    patch 'update_profile', to: 'users/registrations#update_profile'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "products#index"
end
