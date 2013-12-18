require 'bundler/capistrano'
require 'rvm/capistrano'
require "delayed/recipes" 

set :application, "lazuli"
set :scm, :git
set :repository,  "https://pravinhmhatre@bitbucket.org/lazuli_sodel/lazuli.git"
set :deploy_via, :remote_cache

set :use_sudo, false
set :keep_releases, 3

set :precompile_only_if_changed, true
set :rvm_type, :user

default_run_options[:pty] = true 

before "deploy:setup", "db:configure"
before "deploy:assets:precompile", "db:symlink"
after  "deploy:update_code", "db:symlink"
after "deploy:update_code", "deploy:migrate"
after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"

task :qa do
  set :rails_env, "staging"
  set :deploy_to,  "/home/sodel/rails_apps/lazuli"
  set :domain, "192.168.1.119"
  set :user, "sodel"
  set :branch, "master"
  set :scm_verbose, true
  role :web, domain
  role :app, domain
  role :db, domain, :primary=>true
end

# task :prod do
#   set :rails_env, "production"
#   set :deploy_to,  "/home/sodel/rails_apps/lazuli"
#   set :domain, "192.168.1.119"
#   set :user, "sodel"
#   set :branch, "master"
#   set :scm_verbose, true
#   role :web, domain
#   role :app, domain
#   role :db, domain, :primary=>true
#   set :deploy_env, "qa"
# end

namespace :deploy do
  desc "Restart passenger process"
    task :restart, :roles => :app, :except => { :no_release => true } do
      run "touch #{current_path}/tmp/restart.txt"
    end
     
    [:start, :stop].each do |t|
      desc "#{t} does nothing for passenger"
      task t, :roles => :app do ; end
    end
end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

namespace :db do
  desc "Create database yaml in shared path"
  task :configure do
    set :database_name, "#{application}_#{rails_env.downcase}" 

    set :database_username do
      Capistrano::CLI.password_prompt "Database User Name: "
    end

    set :database_password do
      Capistrano::CLI.password_prompt "Database Password: "
    end

    db_config = <<-EOF
      #{rails_env.downcase}:
        database: #{database_name}
        adapter: mysql2
        encoding: utf8
        reconnect: false
        pool: 5
        username: #{database_username}
        password: #{database_password}

    EOF

    run "mkdir -p #{shared_path}/config"
    put db_config, "#{shared_path}/config/database.yml"

    #CREATE DB USER AND DATABASE
    logger.info "CREATING DATABASE #{database_name} AND GRANTING ACCESS TO USER. PLEASE PROVIDE PASSWORD FOR \"MYSQL ROOT USER\""
    set :root_password do
      Capistrano::CLI.password_prompt "MySQL Root Password: "
    end
    run "mysql --user=root --password=#{root_password} -e \"CREATE DATABASE IF NOT EXISTS #{database_name}\""
    run "mysql --user=root --password=#{root_password} -e \"GRANT ALL PRIVILEGES ON #{database_name}.* TO '#{database_username}'@'localhost' IDENTIFIED BY '#{database_password}' WITH GRANT OPTION\""
  end

  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
  end

end

