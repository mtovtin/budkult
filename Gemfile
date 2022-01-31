source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby '2.4.0'
gem 'dalli'
gem 'babosa'
gem 'bootsnap', '>= 1.1.0', require: false
gem "camaleon_cms"
gem 'camaleon_image_optimizer'
gem 'camaleon_post_created_at', github: 'owen2345/camaleon_post_created_at'
gem 'coffee-rails', '~> 4.2'
gem 'momentjs-rails'
gem 'bootstrap-daterangepicker-rails'
gem 'draper', '~> 3'
gem 'flexslider'
gem 'friendly_id', '~> 5.2.4'
gem 'jbuilder', '~> 2.5'
gem 'magnific-popup-rails', '~> 1.1.0'
gem 'mimemagic', github: 'mimemagicrb/mimemagic', ref: '01f92d86d15d85cfd0f20dabd025dcbd36a8a60f'
gem 'mmenu-rails'
gem 'nokogiri'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'responders'
gem 'rails', '~> 5.2.2'
gem 'sass-rails', '~> 5.0'
gem 'savon'
gem 'simple_calendar', :path => 'vendor/gems/simple_calendar'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'whenever', require: false
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'

  gem 'capistrano', '~> 3.11.0'
  gem 'capistrano-bundler', '~> 1.2'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rails', '~> 1.1.3'
  gem 'capistrano-rvm'
  gem "bcrypt_pbkdf"
  end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'chromedriver-helper'
  gem 'selenium-webdriver'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

require './lib/plugin_routes' 
instance_eval(PluginRoutes.draw_gems)