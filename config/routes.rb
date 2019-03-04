Rails.application.routes.draw do
  resources :docker_preview_servers
  resources :websites do
    scope module: :websites do
      resources :resources, constraints: { id: /[^\/]+/ } do
        member do
          get :preview
        end
      end
    end
  end

  root to: redirect("/websites")
end
