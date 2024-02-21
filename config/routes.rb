Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "artworks#index"
  # Dynamic pages:
  get "/:page_name", to: "pages#show"
end
