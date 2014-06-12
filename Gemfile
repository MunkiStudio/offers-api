source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails','~> 4.1.0'
# gem 'rails-api'
gem 'grape',:git =>'https://github.com/intridea/grape.git'
gem 'kaminari'
gem 'grape-kaminari'
gem 'grape-entity'
gem 'grape-rabl'

#API Documentation
gem 'rack-contrib'
gem 'grape-swagger'
gem 'grape-swagger-rails',:git => 'https://github.com/BrandyMint/grape-swagger-rails.git'

# To use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'unicorn'
gem 'geocoder'
gem 'sidekiq'
gem 'sinatra'
gem 'foreman'

# Deploy with Capistrano
# gem 'capistrano', :group => :development

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
gem "paperclip", :git => "git://github.com/thoughtbot/paperclip.git"


group :development, :test do 
	gem 'rspec','3.0.0.beta1'
	gem 'rspec-rails','3.0.0.beta1'
	gem 'factory_girl'
	gem 'factory_girl_rails','~> 4.0'
	gem 'faker'
	gem 'guard-rspec', require: false
	gem 'terminal-notifier-guard'
	gem 'sqlite3'
	gem "better_errors"
	gem "binding_of_caller"
	gem "bullet"
	gem 'debugger'
end

group :test, :development, :darwin do 
	gem 'rb-fsevent'
end

group :test do 
	gem 'database_cleaner'
	gem 'rspec-expectations'
	gem 'rspec-sidekiq'
	gem 'fuubar'
	gem 'simplecov', '~> 0.7.1', :require => false
end

group :production do 
	gem 'pg'
	gem 'rails_12factor'
end
