# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'rails', '~> 6.0.3.2'
gem 'pg', '~> 1.1', '>= 1.1.3'
gem 'puma', '~> 4.3'
gem 'rack-cors', '~> 1.0', '>= 1.0.2'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'blueprinter', '~> 0.22.0'
gem 'jwt', '~> 2.2'
gem 'pundit', '~> 2.1'
gem 'faraday'
gem 'redis-namespace', '~> 1.7'
gem 'sidekiq', '~> 6.0.7'
gem 'haml', '~> 5.1'
gem 'kaminari', '~> 1.2'
gem 'pg_search', '~> 2.3.5'
gem 'nokogiri', '~> 1.11'

group :development, :test do
  gem 'brakeman', '~> 4.3.1', require: false
  gem 'bullet'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 4.11'
  gem 'faker', '~> 1.9.1'
  gem 'json_spec', '~> 1.1'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rspec-rails', '~> 3.8'
  gem 'shoulda-matchers', '~> 4.3.0'
  gem 'simplecov', '~> 0.16.1'
  gem 'rubocop', '~> 0.80.0', require: false
  gem 'rubocop-rails', require: false
  gem 'webmock'
  gem 'travis', '1.8.10'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'

  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
