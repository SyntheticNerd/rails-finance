Rails.application.routes.draw do
  resources :user_stocks, only: [:create, :destroy]
  devise_for :users
  root 'welcome#index'
  get 'my_portfolio', to: 'users#my_portfolio'
  get 'my_friends', to: 'users#my_friends'
  get 'search_friend', to: 'users#search', defaults: { format: 'js' }
  get 'search_stock', to: 'stocks#search', defaults: { format: 'js' }
  get 'refresh_stock', to: 'stocks#refresh', defaults: { format: 'js' }
  resources :friendships, only: %i[create destroy]
  resources :users, only: %i[show]
end
