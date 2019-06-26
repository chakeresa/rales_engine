Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      namespace :merchants do
        scope :find do
          get "/", to: "search#show"
        end
      end

      resources :merchants, only: [:index, :show]
    end
  end
end
