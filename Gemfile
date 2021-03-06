# frozen_string_literal: true
source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 5.0.1"
# Use PostgreSQL as the database for Active Record
gem "pg", "~> 0.18"
# Use Puma as the app server
gem "puma", "~> 3.0"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# Use CoffeeScript for .coffee assets and views
gem "coffee-rails", "~> 4.2"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem "jquery-rails"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"
gem "capybara", "~> 2.12"
gem "factory_girl_rails", "~> 4.8"

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem "simple_form", "~> 3.4.0"
gem "russian", "~> 0.6.0"
gem "sorcery", "~> 0.10.2"
gem "dotenv-rails", "~> 2.2.0"
gem "carrierwave", "~> 1.0"
gem "fog-aws", "~> 1.2.0"
gem "mini_magick", "~> 4.6.1"
# Calculate the levenshtein distance between two strings
gem "levenshtein-ffi", require: 'levenshtein'
gem "whenever", "~> 0.9.7", require: false
gem "sidekiq", "~> 4.2.9"
gem "http_accept_language", "~> 2.1.0"
gem "raygun4ruby", "~> 1.1.12"
gem "newrelic_rpm", "~> 3.18.1.330"
gem "mailgun_rails", "~> 0.9.0"
# Fix --jbuilder warnings
gem "thor", "0.19.1"

group :development, :test do
  # Call 'byebug' anywhere in the code to
  # stop execution and get a debugger console
  gem "byebug", platform: :mri
  gem "rspec-rails", "~> 3.5"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %>
  # anywhere in the code.
  gem "listen", "~> 3.0.5"
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "database_cleaner", "~> 1.5.3"
  gem "rails-controller-testing", "~> 1.0.1", require: false
  gem "simplecov"
  gem "codeclimate-test-reporter", "~> 1.0.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
