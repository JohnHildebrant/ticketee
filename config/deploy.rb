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
set :port, 22
set :user, "ticketeeapp.com"
set :deploy_to, "/home/ticketeeapp.com/apps/#{application}"
set :use_sudo, false
set :keep_releases, 5

load 'deploy/assets'

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "blackops.wz.hasbro.com"                   # Your HTTP server, Apache/etc
role :app, "blackops.wz.hasbro.com"                   # This may be the same as your `Web` server
role :db,  "blackops.wz.hasbro.com", :primary => true # This is where Rails migrations will run

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

namespace :delayed_job do
  desc "Start delayed_job process"
  task :start, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=production script/delayed_job start"
  end
  
  desc "Stop delayed_job process"
  task :stop, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=production script/delayed_job start"
  end
  
  desc "Restart delayed_job process"
  task :restart, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=production script/delayed_job restart"
  end
end

task :symlink_database_yml do
  run "rm #{release_path}/config/database.yml"
  run "ln -sfn #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

task :symlink_mail_rb do
  run "rm -f #{release_path}/config/initializers/mail.rb"
  run "ln -sfn #{shared_path}/config/initializers/mail.rb #{release_path}/config/initializers/mail.rb"
end

task :symlink_mail_yml do
  run "rm -f #{release_path}/config/mail.yml"
  run "ln -sfn #{shared_path}/config/mail.yml #{release_path}/config/mail.yml"
end

task :symlink_files do
  run "rm -rf #{release_path}/files"
  run "ln -sfn #{shared_path}/files #{release_path}/files"
end

task :to_do_after_deploy do
  symlink_database_yml
  symlink_mail_rb
  symlink_mail_yml
  symlink_files
end

after "bundle:install", "to_do_after_deploy"
after "deploy:start", "delayed_job:start"
after "deploy:stop", "delayed_job:stop"
after "deploy:restart", "delayed_job:restart"
