Rails.application.routes.draw do
  
  devise_for :users, controllers: { registrations: 'users/registrations' }
  
  root to: 'homes#top'
  get "home/about"=>"homes#about",as: 'about'
  get 'searches/search'
  # get '/users/:id/shelter' => 'users#shelter', as: 'shelter'
  
  resources :users, only: [:index, :show, :edit, :update]do
    resource :relationships, only: [:create, :destroy]
    get 'shelter' => 'users#shelter', as: 'shelter'
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    get 'unsubscribe', to: 'users#unsubscribe', as: 'unsubscribe'
    patch 'withdraw', to: 'users#withdraw', as: 'withdraw'
  end
  
  resources :articles, only: [:index, :show, :edit, :new, :create, :destroy, :update] do
    resource :favorites,only:[:create, :destroy, :show]
    resources :post_comments,only:[:create, :destroy]
  end
  
  resources :notifications, only: [:index, :destroy]
  
  resources :chats, only: [:index, :show, :create]

end