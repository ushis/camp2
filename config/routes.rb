Rails.application.routes.draw do
  match '*path', controller: :application, action: :options, via: :options

  namespace :v1 do
    resource :profile, only: [:show, :create, :update, :destroy]
    resource :session, only: [:create]
    resource :acception, only: [:create]

    resources :topics, only: [:index, :show, :create, :update, :destroy] do
      resources :shares, only: [:index, :show, :destroy]
      resources :invitations, only: [:index, :show, :create, :destroy]

      resources :lists, only: [:index, :show, :create, :update, :destroy] do
        resources :items, only: [:index, :show, :create, :update, :destroy] do
          resources :comments, only: [:index, :show, :create, :update, :destroy]
        end
      end
    end
  end
end
