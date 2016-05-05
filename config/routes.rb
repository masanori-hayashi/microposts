Rails.application.routes.draw do
  root to: 'static_pages#home'
  get    'signup', to: 'users#new'
  get    'login' , to: 'sessions#new'
  post   'login' , to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users do#７つのルーティングしかない、followers followingsを追加
    member do
      get 'followers' #users/1/followers to: 'users#followers'
      get 'followings'
    end
  # collection do
  #     get 'followers' #users/followers to: 'users#followers'
  #     get 'followings'
  #   end
  end

  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts
  # get 'index', to: 'micropost#index'       # /microposts
  # get 'show', to: 'micropost#show'         # /microposts/1
  # get 'new', to: 'micropost#new'           # /microposts/new
  # post 'create', to: 'micropost#create'    # /microposts
  # get 'edit', to: 'micropost#edit'         # /microposts/1/edit
  # patch 'update', to: 'micropost#update'   # /microposts/1
  # delte 'destroy', to: 'micropost#destroy' # /microposts/1
  resources :relationships, only: [:create, :destroy]
end