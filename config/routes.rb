Rails.application.routes.draw do
  get '/about' => 'pages#about'
  get '/feedback' => 'pages#feedback'
  root 'topics#index'
  get '/topics' => 'topics#index'
  get 'topics/index'
  get 'topics/show'
  devise_for :users, path: :auth
end
