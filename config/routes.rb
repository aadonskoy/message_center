Rails.application.routes.draw do
  root "messages#index"

  namespace :api do
    resource :messages, only: :create
    namespace :webhooks do
      resource :messages, only: :create
    end
  end

  resources :messages, only: :index
end
