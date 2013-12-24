require 'bundler/capistrano'
require 'rvm/capistrano'
require "delayed/recipes"

load "config/recipes/requirements"
load "config/recipes/db"
load "config/recipes/rvm"
load "config/recipes/passenger"

set :application, "lazuli"
set :scm, :git
set :repository,  "https://pravinhmhatre@bitbucket.org/lazuli_sodel/lazuli.git"
set :deploy_via, :remote_cache

set :use_sudo, false
set :keep_releases, 3

set :precompile_only_if_changed, true
set :rvm_type, :user

set :app_requirements, ['mysql', 'sphinx']

default_run_options[:pty] = true 

before "db:configure", "requirements:check"
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

