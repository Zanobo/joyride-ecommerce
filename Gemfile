source 'http://rubygems.org'

ruby  '2.3.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
#gem 'sdoc', '~> 0.4.0', group: :doc
gem 'solidus', '~> 2.2'
gem 'solidus_auth_devise', '~> 1.5'
gem 'paperclip', '~> 5.1'
gem 'sidekiq', '~> 5.0'
gem 'sidekiq-cron', '~> 0.4.0'
gem 'bootstrap-sass', '~> 3.3'
gem 'simple_calendar', '~> 2.2'
gem 'httparty', '~> 0.15'
gem 'figaro', '~> 1.1'
gem 'rollbar'
gem 'oj', '~> 2.12.14'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

platforms :ruby do # linux
  gem 'unicorn', '~> 5.3'
  gem 'aws-sdk', '~> 2.9'
end

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'sqlite3'
  gem 'pry'
end

group :test do
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'database_cleaner', '~> 1.6'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
