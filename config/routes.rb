Rails.application.routes.draw do
  root to: 'posts#index'
  get 'sign_up', to: "users#new"
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'

  resources :posts do
    resources :comments
	resources :votes, only: [:create, :update, :destroy]
  end
  resources :comments do
    resources :comments
    resources :votes, only: [:create, :update, :destroy]
  end
  resources :users do
	get 'followers', 'following'
  end
  resources :relationships, only: [:create, :destroy]
  match '*path', to: redirect('/'), via: [:get,:post]
end
