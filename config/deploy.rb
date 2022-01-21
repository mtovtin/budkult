

set :application, 'Rada-uzhgorod'
set :repo_url, 'ssh://mrmiko2@bitbucket.org/mrmiko2/rada-copy.git'
set :user, 'deploy'
set :deploy_to, '/home/deploy/rada'

set :linked_files, %w{config/database.yml config/master.key}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/media public/old_media public/assets public/ckeditor_assets public/uploads}
set :keep_assets, 2

namespace :deploy do
	desc 'Restart application'
	task :restart do
		on roles(:app), in: :sequence, wait: 5 do
			execute :touch, release_path.join('tmp/restart.txt')
		end
	end

	after :publishing, 'deploy:restart'
	after :finishing, 'deploy:cleanup'
end

require "whenever/capistrano"

set :whenever_roles, -> { [:app, :web] }
set :whenever_environment, fetch(:stage)
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }
set :rvm_ruby_version, '2.5.2'