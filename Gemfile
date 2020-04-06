# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'rails', '~> 6.0.2.1'
gem 'pg', '~> 1.1', '>= 1.1.3'
gem 'puma', '~> 4.3'
gem 'rack-cors', '~> 1.0', '>= 1.0.2'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'blueprinter', '~> 0.22.0'
gem 'jwt', '~> 2.2'
gem 'pundit', '~> 2.1'
gem 'faraday'

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
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
