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
    end

    nested do
      resources :events do
        nested do
          scope ':year/:month/:day' do
            get 'availability' => 'availability#show'
            put 'availability' => 'availability#update'
          end

          get ':year/:month/:day' => "events#show", as: :occurrence
        end
      end
    end

    resources :members
    resources :roles, except: %i[new edit] do
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
