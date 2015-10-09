Rails.application.routes.draw do

  root "dashboard#index"

  namespace :api do
    namespace :v1 do
      resources :items
    end
  end
end
