Rails.application.routes.draw do
  get 'calendar/index'

  devise_for :users,
    controllers: {
      omniauth_callbacks: 'omniauth',
      registrations: 'users/registrations',
      sessions: 'users/sessions'
    }

  get '/calendar(/:year(/:month))' => 'calendar#index'

  resources :teams do
    post :check, on: :collection

    resources :events
    resources :members

    get '/calendar(/:year(/:month))' => 'calendar#index'
  end

  resources :invitations, only: %i(show) do
    member do
      post :accept
      post :decline
    end
  end

  root to: 'teams#index'

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
