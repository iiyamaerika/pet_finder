Rails.application.routes.draw do
  
  devise_for :users
  
  root to: 'homes#top'
  get "home/about"=>"homes#about",as: 'about'
  
  resources :users, only: [:show, :edit, :update]do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  
  resources :articles, only: [:index, :show, :edit, :new, :create, :destroy, :update] do
    resource :favorites,only:[:create, :destroy, :show]
    resources :post_comments,only:[:create, :destroy]
  end
  
  resources :chats, only: [:index, :show, :create]

end