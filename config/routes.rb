# frozen_string_literal: true

Rails.application.routes.draw do
  get 'about', to: 'about#index'
  get 'privacy', to: 'privacy#index'
  get 'terms', to: 'terms#index'
  get 'logins/login'
  get 'logins/sign_up'
  # get 'home/index'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new'
    get 'sign_up', to: 'users/registrations#new'
    get 'users/sign_out', to: 'users/sessions#destroy'
  end

  root 'home#index'

  resources :users, param: :monofy_id do
    # @like 「いいね」した時に「votes」テーブルにレコードを作成
    # @unlike 自分の投票を削除
    # @voted 自分の投票の記事一覧を表示
    # member { patch "like", "unlike" }
    # collection { get "voted" }
    # collection { get "search" }
    # resources :messages, only: [:index,:show]
    resources :messages, param: :url_token
  end

  # resources :messages

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
