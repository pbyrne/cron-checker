source 'https://rubygems.org'
ruby "2.1.1"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'
gem 'haml'
gem 'unicorn'
gem 'newrelic_rpm'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Configure the app to be Heroku-friendly
gem 'rails_12factor', group: :production

group :development, :test do
  gem 'capybara'
  gem 'rspec-rails', '< 3' # for now, looks like some breaking changes in rspec 3
  gem 'simplecov', require: false
  gem 'foreman'
end
