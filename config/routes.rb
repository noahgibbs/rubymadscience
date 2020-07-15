Rails.application.routes.draw do
  get '/about' => 'pages#about'
  get '/feedback' => 'pages#feedback'
  get '/profile' => 'pages#profile'

  root 'topics#index'
  get '/topics' => 'topics#index'
  get 'topics/index'
  get 'topics/show', to: "topics#show"
  get 'topics/:id', to: "topics#show"

  post 'topics/update_subscription'
  post 'steps/update_done'

  devise_for :users, path: :auth, controllers: {
    confirmations: 'users/confirmations',
  }
end
