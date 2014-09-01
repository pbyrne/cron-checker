source 'https://rubygems.org'
ruby "2.1.1"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'haml'
gem 'rails', '4.1.5'
gem 'sass-rails', '~> 4.0.0'
gem 'unicorn'

group :production do
  # Configure the app to be Heroku-friendly
  gem 'rails_12factor', group: :production
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'capybara'
  gem 'rspec-rails'
  gem 'simplecov', require: false
  gem 'foreman'
end
