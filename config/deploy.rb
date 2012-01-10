$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) 
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.2'
set :rvm_type, :system
set :rvm_bin_path, '/usr/local/rvm/bin'

require 'bundler/capistrano'

set :application, "ticketee"
set :repository,  "git@github.com:Jth3000/ticketee.git"

set :branch, "production"

set :scm, :git
set :port, 2200
set :user, "ticketeeapp.com"
set :deploy_to, "/home/ticketeeapp.com/apps/#{application}"
set :use_sudo, false
set :keep_releases, 5

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "localhost"                          # Your HTTP server, Apache/etc
role :app, "localhost"                          # This may be the same as your `Web` server
role :db,  "localhost", :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

task :symlink_database_yml do
  run "rm #{release_path}/config/database.yml"
  run "ln -sfn #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

after "bundle:install", "symlink_database_yml"

after 'deploy:update_code' do
  load 'deploy/assets'
end