if ENV['USE_OFFICIAL_GEM_SOURCE']
  source 'https://rubygems.org'
else
  source 'https://ruby.taobao.org'
end

gem 'rails', '~> 5.0.0'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
# gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
# gem 'redis', '~> 3.0'
# gem 'bcrypt', '~> 3.1.7'
gem 'pry-rails'
gem 'pg'
gem 'devise'
gem 'jwt'
gem 'base32'
gem 'font-awesome-sass'
gem 'font-ionicons-rails', git: 'https://github.com/ricardoemerson/font-ionicons-rails.git'
gem 'bootstrap-sass'
gem 'default_value_for'
gem 'httparty'
gem 'icheck-rails'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'sinatra', require: false, git: 'https://github.com/sinatra/sinatra.git' # https://github.com/mperham/sidekiq/issues/2839
gem 'rack-protection', git: 'https://github.com/sinatra/rack-protection.git' # https://github.com/sinatra/sinatra/issues/1152
gem 'kaminari', git: 'https://github.com/amatsuda/kaminari.git', branch: '0-17-stable'
gem 'http_accept_language'
gem 'cancancan'
gem 'rack-mini-profiler'
gem 'github-markup', require: 'github/markup'
gem 'redcarpet'
gem 'rails-settings-cached'
gem 'rails-i18n', '~> 5.0.0'
gem 'redis'
gem 'paranoia', git: 'https://github.com/rubysherpas/paranoia.git', branch: 'rails5'

# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'better_errors'
  gem 'binding_of_caller'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
