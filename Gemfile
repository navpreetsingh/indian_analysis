source 'https://rubygems.org'
ruby '2.0.0'
#ruby-gemset=railstutorial_rails_4_0

gem 'rails', '4.0.0'
gem 'bootstrap-sass', '2.3.2.0'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.1.2'
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.9'

group :development, :test do
  gem 'sqlite3', '1.3.8'
  gem 'rspec-rails', '2.13.1'
  gem 'mysql', '2.9.1'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
  gem 'factory_girl_rails', '4.2.1'
  gem 'cucumber-rails', '1.4.0', :require => false
  gem 'database_cleaner', github: 'bmabey/database_cleaner'
end

gem 'sass-rails', '4.0.0'  # Use SCSS for stylesheets
gem 'uglifier', '2.1.1' # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '4.0.0' # Use CoffeeScript for .js.coffee assets and views
gem 'jquery-rails', '3.0.4' # Use jquery as the JavaScript library
gem 'turbolinks', '1.1.1' # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'jbuilder', '1.0.2' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'therubyracer'


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end

# Use debugger
gem 'debugger', group: [:development, :test]