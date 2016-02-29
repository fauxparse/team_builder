Rails.application.routes.draw do
  devise_for :users,
    :controllers => { :omniauth_callbacks => 'omniauth' }

  # TODO: these are temporary routes to get the UI working
  get '/calendar' => 'teams#index'

  resources :teams
  root to: 'teams#index'

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
