Rails.application.routes.draw do
  resources :websites do
    scope module: :websites do
      resources :resources, constraints: { id: /[^\/]+/ } do
        member do
          get :preview
        end
      end
    end
  end
end
