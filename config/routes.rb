Rails.application.routes.draw do
  resources :bottles do
    collection do
      get "/:filter", to: "bottles#index", as: :filtered, constraints: { filter: /open|finished/ }
    end
  end
  root to: "bottles#index"
end
