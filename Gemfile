source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'dynamic_form'
  gem 'uglifier'
end

gem 'devise', '~> 1.4.3'
gem 'cancan'
gem 'paperclip'
gem 'searcher'
gem 'jquery-rails'
gem 'ruby-debug19', :require => 'ruby-debug'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :development do
  gem 'capistrano'
end

group :test, :development do
  gem 'rspec-rails', '~> 2.5'
  gem 'gmail'
  gem 'sqlite3'
end

group :test do
  gem 'cucumber-rails', '~> 1.0.6'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'email_spec'
  gem 'launchy'
end

group :production do
  gem 'pg'
end