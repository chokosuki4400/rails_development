Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }

  resources :users do
    # @like 「いいね」した時に「votes」テーブルにレコードを作成
    # @unlike 自分の投票を削除
    # @voted 自分の投票の記事一覧を表示
    # member { patch "like", "unlike" }
    # collection { get "voted" }
    # collection { get "search" }
    # resources :messages, only: [:index,:show]
    resources :messages
  end

  # resources :messages

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
