source 'https://rubygems.org'
ruby '2.2.2'

gem 'rails', '4.2.1'

# api
gem 'jbuilder', '~> 2.0'

# core
gem 'kaminari'
gem 'devise'
gem 'pundit'
gem 'simple_token_authentication', '~> 1.0'

# gem 'apipie-rails', :github => 'Apipie/apipie-rails'

group :development, :test do
  gem 'spring'
  gem 'annotate'
  gem 'binding_of_caller'
  gem 'better_errors'
  gem 'quiet_assets'
  gem 'byebug'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'sqlite3'

  gem 'rspec-core'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'airborne'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'puma'
  gem 'rack-timeout'
end
