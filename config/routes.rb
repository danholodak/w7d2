Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "users#index"
  resource :session, only: [:create, :destroy, :new]
  resources :users, only: [:new, :create, :show]
  resources :bands
end
