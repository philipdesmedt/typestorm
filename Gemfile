source 'https://rubygems.org'

gem 'rails', '4.1.6'
gem 'pg'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development
gem 'bcrypt', '~> 3.1.7'
gem 'httparty'
gem 'figaro'
gem 'nokogiri'
gem 'differ'

# Use unicorn as the app server
# gem 'unicorn'

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'letter_opener'
  gem 'meta_request'
  gem 'better_errors' #literally what it says
  gem 'binding_of_caller' #adds REPL to better_errors
  gem 'guard-livereload' #adds live reload
  gem 'rack-livereload'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'annotate'
  gem 'simplecov', require: false
end
