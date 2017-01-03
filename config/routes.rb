Rails.application.routes.draw do
  devise_for :users
  resources :bottles do
    collection do
      get "/:filter", to: "bottles#index", as: :filtered, constraints: { filter: /open|finished|unstocked/ }
      get "/toggle_inventory", to: "bottles#toggle_inventory", as: :toggle_inventory
    end

    member do
      get "/duplicate", to: "bottles#duplicate", as: :duplicate
      get "/stock", to: "bottles#stock", as: :stock
      get "/unstock", to: "bottles#unstock", as: :unstock
    end
  end

  root to: "bottles#index"
end
