Rails.application.routes.draw do
  get 'calendar/index'

  devise_for :users,
    controllers: {
      omniauth_callbacks: 'omniauth',
      registrations: 'users/registrations',
      sessions: 'users/sessions'
    }

  get '/calendar/:year/:month/:day' => 'calendar#show'
  get '/calendar(/:year(/:month))' => 'calendar#index'

  resources :teams do
    post :check, on: :collection
    post :check, on: :member

    get '/calendar/:year/:month/:day' => 'calendar#show'
    get '/calendar(/:year(/:month))' => 'calendar#index'

    resources :events do
      get '/:year/:month/:day' => :show, on: :member, as: :specific
    end

    resources :members
    resources :roles, except: [:new, :edit] do
      post :check, on: :collection
      post :check, on: :member
    end

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
