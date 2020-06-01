Rails.application.routes.draw do
  root 'topics#index'
  get 'topics/index'
  get 'topics/show'
  devise_for :users, path: :auth
end
