# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'
gem 'rails', '5.2.0'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.0'

# Use Puma as the app server
gem 'puma', '~> 3.12'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 3.5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Template Engine
gem 'slim-rails', '~> 3.1'

# App monitoring
gem 'newrelic_rpm', '~> 5.3'

group :development, :test do
  gem 'byebug', '~> 10.0', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 4.10'
  gem 'faker', '~> 1.9'
  gem 'pry', '~> 0.11.3'
  gem 'pry-byebug', '~> 3.6'
  gem 'pry-rails', '~> 0.3.6'
  gem 'rspec-rails', '~> 3.7'
  gem 'rubocop', '~> 0.58.2', require: false
  gem 'rubocop-rspec', '~> 1.27', require: false
  gem 'slim_lint', '~> 0.15.1', require: false
end

group :development do
  # gem 'better_errors', '~> 2.4'
  # gem 'binding_of_caller', '~> 0.7.3'
  # gem 'bullet', '~> 5.6'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # gem 'meta_request', '~> 0.4.3'
  gem 'spring', '~> 2.0'
  gem 'spring-commands-rspec', '~> 1.0'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '~> 3.6'
end

group :test do
  gem 'capybara', '~> 3.5'
  gem 'capybara-screenshot', '~> 1.0'
  gem 'coveralls_reborn', '~> 0.12.0', require: false
  gem 'database_cleaner', '~> 1.7'
  gem 'email_spec', '~> 2.2'
  gem 'poltergeist', '~> 1.18'
  gem 'simplecov', '~> 0.16.1', require: false
  gem 'webmock', '~> 3.4', require: false
end

group :staging, :production do
  gem 'rack-timeout', '~> 0.5.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '~> 1.2018', platforms: %i[mingw mswin x64_mingw jruby]
