# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.8"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use pg as the database for Active Record
gem "pg"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Devise is a flexible authentication solution for Rails based on Warden [https://github.com/heartcombo/devise]
gem "devise", "~> 4.9"

# devise-api authenticate API requests [https://github.com/nejdetkadir/devise-api]
gem "devise-api", github: "nejdetkadir/devise-api", branch: "main"

# Rack::Cors provides support for Cross-Origin Resource Sharing (CORS) for Rack compatible web applications [https://github.com/cyu/rack-cors]
gem "rack-cors"

# Swagger to Rails-based API's [https://github.com/rswag/rswag]
gem "rswag"

# Simple, efficient background processing for Ruby [https://github.com/sidekiq/sidekiq]
gem "sidekiq"

# Elasticsearch with chewy [https://github.com/toptal/chewy]
gem "chewy"

# Ruby implementation of GraphQL [https://github.com/rmosolgo/graphql-ruby]
gem "graphql"

# Active Model Serializer [https://github.com/rails-api/active_model_serializers]
gem "active_model_serializers"

# This Ruby gem lets you move your application logic into small composable service objects. [https://github.com/sunny/actor]
gem "service_actor", "~> 3.7"
# ServiceActor-Rails provides Rails support for the ServiceActor gem. [https://github.com/sunny/actor-rails]
gem "service_actor-rails", "~> 1.0"

# Provides CSRF protection on OmniAuth request endpoint on Rails application.
gem "omniauth-rails_csrf_protection"

# GitHub strategy for OmniAuth
gem "omniauth-github"

# GitHub strategy for Strava
gem "omniauth-strava"

# Packages sturcture support
gem "packwerk"

# A Scope & Engine based, clean, powerful, customizable and sophisticated paginator for Ruby webapps
gem "kaminari"

# Minimal authorization through OO design and pure Ruby classes
gem "pundit"

group :development, :test do
  gem "bullet"

  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "factory_bot_rails"
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "graphiql-rails"
  gem "pry", "~> 0.14.2"
end

group :development do
  # To ensure code consistency [https://docs.rubocop.org]
  gem "rubocop", "1.56.2"
  gem "rubocop-graphql", "~> 1.4"
  gem "rubocop-performance", "1.19.0"
  gem "rubocop-rails", "2.20.2"
  gem "rubocop-rspec", "2.23.2"
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  gem "brakeman"
  gem "reek"
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "rspec-rails", "~> 6.0.0"
  gem "rspec-sidekiq"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 5.0"
  gem "simplecov", require: false
  gem "spring-commands-rspec"
end
