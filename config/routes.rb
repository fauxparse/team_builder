Rails.application.routes.draw do
  get 'calendar/index'

  devise_for :users,
    :controllers => { :omniauth_callbacks => 'omniauth' }

  get '/calendar(/:year(/:month))' => 'calendar#index'

  resources :teams do
    resources :events
  end
  root to: 'teams#index'

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
