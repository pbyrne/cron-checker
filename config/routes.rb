CronChecker::Application.routes.draw do
  get "/check", to: "checker#show", as: :check
  root "checker#index"
end
