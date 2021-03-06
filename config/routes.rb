Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  
  namespace :admin do
    root to: 'users#index'
    resources :users, only: [:index, :edit, :update] 
    get 'users/search', to: 'users#search'
  end

  root to: 'homes#top'
  get "home/about" => "homes#about", as: 'about'
  get 'searches/search'

  resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    get 'shelter' => 'users#shelter', as: 'shelter'
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    get 'unsubscribe', to: 'users#unsubscribe', as: 'unsubscribe'
    patch 'withdraw', to: 'users#withdraw', as: 'withdraw'
  end

  resources :articles, only: [:index, :show, :edit, :new, :create, :destroy, :update] do
    resource :favorites, only: [:create, :destroy, :show]
    resources :post_comments, only: [:create, :destroy]
  end

  resources :notifications, only: [:index, :destroy]

  resources :chats, only: [:index, :show, :create]

  # 問い合わせ
  resources :contacts, only: [:new, :create]
  post 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'
  post 'contacts/back', to: 'contacts#back', as: 'back'
  get 'done', to: 'contacts#done', as: 'done'
end
