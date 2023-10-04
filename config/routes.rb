Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get "/home/about" => "homes#about", as:"about"
  get "search"      => "searches#search"
  
  resources :users, only: [:show, :edit, :index, :update] do
    # member do
    #   get :follows, :followers
    # end
    #   resource :relationships, only: [:create, :destory]
    
    resource :relationships, only: [:create, :destroy]
    get 'follows' => 'users#follows'
    get 'followers' => 'users#followers'
  end
  
  resources :books, only: [:create, :index, :show, :destroy, :edit, :update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
