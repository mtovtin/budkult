source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby '2.4.0'

gem 'rails', '~> 5.2.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'camaleon_cms',  '>= 2.5.0'
gem 'camaleon_post_created_at', github: 'owen2345/camaleon_post_created_at'
gem 'camaleon_image_optimizer'
gem 'draper', '~> 3'
gem 'nokogiri'
gem 'simple_calendar', :path => 'vendor/gems/simple_calendar'
gem 'flexslider'
gem 'magnific-popup-rails', '~> 1.1.0'
gem 'mmenu-rails'
gem 'friendly_id', '~> 5.2.4'
gem 'babosa'
gem 'dalli'
gem 'whenever', require: false
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'annotate'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano', '~> 3.7', '>= 3.7.1'
  gem 'capistrano-bundler', '~> 1.2'
  gem 'capistrano-rails', '~> 1.1.3'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rvm'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

require './lib/plugin_routes' 
instance_eval(PluginRoutes.draw_gems)