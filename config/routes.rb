Rails.application.routes.draw do
  resources :bottles
  root to: "bottles#index"
end
