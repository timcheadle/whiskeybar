Rails.application.routes.draw do
  resources :bottles do
    collection do
      get "/:filter", to: "bottles#index", as: :filtered
    end
  end
  root to: "bottles#index"
end
