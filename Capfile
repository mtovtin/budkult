require 'capistrano/setup'

require 'capistrano/deploy'
require 'capistrano/rvm'
set :rvm_type, :user
set :rvm_ruby_version, '2.5.2'

require 'capistrano/bundler'
require 'capistrano/rails'
require 'whenever/capistrano'

#require 'capistrano/master_key'

Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }