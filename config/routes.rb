Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get "/find", to: "search#show"
        get "/find_all", to: "search#index"
        get "/random", to: "random#show"
        get "/most_revenue", to: "most_revenue#index"
        get "/most_items", to: "most_items#index"
        get "/revenue", to: "revenue#index"
        get "/:id/revenue", to: "revenue#show"
        get "/:id/favorite_customer", to: "favorite_customer#show"
      end

      resources :merchants, only: [:index, :show] do
        scope module: :merchants do
          resources :items, only: [:index]
          resources :invoices, only: [:index]
        end
      end

      namespace :items do
        get "/find", to: "search#show"
        get "/find_all", to: "search#index"
        get "/random", to: "random#show"
        get "/most_revenue", to: "most_revenue#index"
        get "/most_items", to: "most_items#index"
      end

      resources :items, only: [:index, :show] do
        scope module: :items do
          resources :invoice_items, only: [:index]
          get "/merchant", to: "merchants#show"
          get "/best_day", to: "best_day#show"
        end
      end

      namespace :customers do
        get "/find", to: "search#show"
        get "/find_all", to: "search#index"
        get "/random", to: "random#show"
        get "/:id/favorite_merchant", to: "favorite_merchant#show"
      end

      resources :customers, only: [:index, :show] do
        scope module: :customers do
          resources :invoices, only: [:index]
          resources :transactions, only: [:index]
        end
      end

      namespace :invoices do
        get "/find", to: "search#show"
        get "/find_all", to: "search#index"
        get "/random", to: "random#show"
      end

      resources :invoices, only: [:index, :show] do
        scope module: :invoices do
          resources :transactions, only: [:index]
          resources :invoice_items, only: [:index]
          resources :items, only: [:index]
          get "/customer", to: "customers#show"
          get "/merchant", to: "merchants#show"
        end
      end

      namespace :invoice_items do
        get "/find", to: "search#show"
        get "/find_all", to: "search#index"
        get "/random", to: "random#show"
      end

      resources :invoice_items, only: [:index, :show] do
        scope module: :invoice_items do
          get "/invoice", to: "invoices#show"
          get "/item", to: "items#show"
        end
      end
    end
  end
end
