require 'bundler/capistrano'
require 'rvm/capistrano'

set :application, "lazuli"
set :repository,  "https://pravinhmhatre@bitbucket.org/lazuli_sodel/lazuli.git"
set :deploy_to,  "/home/sodel/rails_apps/lazuli"
set :applicationdir,  "/home/sodel/rails_apps/lazuli"

set :use_sudo, false
set :scm, :git
set :keep_releases, 3
set :rails_env, "production"
set :precompile_only_if_changed, true

set :rvm_type, :user

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`


# deploy config
set :deploy_to, applicationdir
set :deploy_via, :export

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
# default_run_options[:shell] = '/bin/bash --login'

#ssh_options[:keys] = %w(/Path/To/id_rsa)            # If you are using ssh_keys
#set :chmod755, "app config db lib public vendor script script/* public/disp*"
#set :use_sudo, true

task :qa do
  set :domain, "192.168.1.119"
  set :user, "sodel"
  set :branch, "master"
  set :scm_verbose, true
  role :web, domain
  role :app, domain
  role :db, domain, :primary=>true
  set :deploy_env, "qa"
end

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




before "deploy:setup", "db:configure"
after  "deploy:update_code", "db:symlink"
after "deploy:update_code", "deploy:migrate"
before "deploy:assets:precompile", "db:symlink"

namespace :db do
  desc "Create database yaml in shared path"
  task :configure do
    set :database_username do
      "lazuli"
    end

    set :database_password do
      Capistrano::CLI.password_prompt "Database Password: "
    end

    db_config = <<-EOF
      base: &base
        adapter: mysql2
        encoding: utf8
        reconnect: false
        pool: 5
        username: #{database_username}
        password: #{database_password}

      development:
        database: #{application}_development
        <<: *base

      test:
        database: #{application}_test
        <<: *base

      production:
        database: #{application}_production
        <<: *base
    EOF

    run "mkdir -p #{shared_path}/config"
    put db_config, "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
  end
end

