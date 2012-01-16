CronChecker::Application.routes.draw do
  # left in for the view specs
  # TODO figure out how to do the view specs without these
  get 'checker/index'
  get 'checker/check'

  match 'check' => 'checker#check', :as => :checker
  root :to => "checker#index"
end
