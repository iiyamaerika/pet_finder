Rails.application.routes.draw do
  
  devise_for :users, controllers: { registrations: 'users/registrations' }
  
  root to: 'homes#top'
  get "home/about"=>"homes#about",as: 'about'
  get 'searches/search'
  
  resources :users, only: [:index, :show, :edit, :update]do
    resource :relationships, only: [:create, :destroy]
    get 'shelter' => 'users#shelter', as: 'shelter'
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  
  resources :articles, only: [:index, :show, :edit, :new, :create, :destroy, :update] do
    resource :favorites,only:[:create, :destroy, :show]
    resources :post_comments,only:[:create, :destroy]
  end
  
  resources :notifications, only: [:index, :destroy]
  
  resources :chats, only: [:index, :show, :create]

end