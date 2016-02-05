Rails.application.routes.draw do
  devise_for :users,
    :controllers => { :omniauth_callbacks => 'omniauth' }

  root to: 'teams#index'

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
