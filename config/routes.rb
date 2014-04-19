CronChecker::Application.routes.draw do
  get "/check", to: "checker#show", as: :check
  get "/styleguide", to: "styleguide#index", as: :styleguide
  root "checker#index"
end
