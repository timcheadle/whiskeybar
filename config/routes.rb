Rails.application.routes.draw do
  devise_for :users
  resources :bottles do
    collection do
      get "/:filter", to: "bottles#index", as: :filtered, constraints: { filter: /open|finished|sell|stocked|unstocked/ }
      get "/search", to: "bottles#search", as: :search
      get "/toggle_inventory", to: "bottles#toggle_inventory", as: :toggle_inventory
      get "/reset_stock", to: "bottles#reset_stock", as: :reset_stock
    end

    member do
      get "/duplicate", to: "bottles#duplicate", as: :duplicate
      get "/stock", to: "bottles#stock", as: :stock
      get "/unstock", to: "bottles#unstock", as: :unstock
      get "/open", to: "bottles#crack_open", as: :open
      get "/finish", to: "bottles#finish", as: :finish
      get "/sell", to: "bottles#sell", as: :sell
    end
  end

  root to: "bottles#index"
end
