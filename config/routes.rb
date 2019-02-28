Rails.application.routes.draw do
  resources :websites do
    scope module: :websites do
      resources :resources, constraints: { id: /[^\/]+/ }
    end
  end
end
