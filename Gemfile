# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.8'
gem 'rails', '5.2.6'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.2'

# Use Puma as the app server
gem 'puma', '~> 5.4'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.4'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.9', require: false

# Template Engine
gem 'slim-rails', '~> 3.3'

# App monitoring
gem 'newrelic_rpm', '~> 8.0'

group :development, :test do
  gem 'byebug', '~> 11.1', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 2.19'
  gem 'pry', '~> 0.13.1'
  gem 'pry-byebug', '~> 3.9'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rspec-rails', '~> 5.0'
  gem 'rubocop', '~> 1.21', require: false
  gem 'rubocop-performance', '~> 1.11', require: false
  gem 'rubocop-rails', '~> 2.12', require: false
  gem 'rubocop-rspec', '~> 2.4', require: false
  gem 'slim_lint', '~> 0.22.1', require: false
end

group :development do
  # gem 'better_errors', '~> 2.4'
  # gem 'binding_of_caller', '~> 0.7.3'
  # gem 'bullet', '~> 5.6'
  gem 'listen', '>= 3.0.5', '< 3.8'
  # gem 'meta_request', '~> 0.4.3'
  gem 'spring', '~> 2.1'
  gem 'spring-commands-rspec', '~> 1.0'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '~> 3.7'
end

group :test do
  gem 'capybara', '~> 3.35'
  gem 'email_spec', '~> 2.2'
  gem 'selenium-webdriver', '~> 3.142'
  gem 'simplecov', '~> 0.21.2', require: false
  gem 'simplecov-lcov', '~> 0.8.0', require: false
  gem 'webmock', '~> 3.14', require: false
end

group :staging, :production do
  gem 'rack-timeout', '~> 0.6.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '~> 1.2019', platforms: %i[mingw mswin x64_mingw jruby]
