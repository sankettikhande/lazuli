
# This overrides default delayed_job tasks to support args per role
# If you want to use command line options, for example to start multiple workers,
# define a Capistrano variable delayed_job_args_per_role:
#
#   set :delayed_job_args_per_role, {:worker_heavy => "-n 4",:worker_light => "-n 1" }
#
# Target server roles are taken from delayed_job_args_per_role keys.
namespace :delayed_job do

  def args_per_host_role(host,role)
    find_servers(:roles => role).each do |server|
      return args[role] if server.host == host
    end
  end

  def args
    fetch(:delayed_job_args_per_role, {:app => ""})
  end

  def roles
    args.keys
  end

  desc "Start the delayed_job process"
  task :start, :roles => lambda { roles } do
    roles.each do |role|
      find_servers_for_task(current_task).each do |server|
        run "cd #{current_path};#{rails_env} script/delayed_job #{args_per_host_role server.host,role} start", :hosts => server.host
      end
    end
  end

  desc "Restart the delayed_job process"
  task :restart, :roles => lambda { roles } do
    roles.each do |role|
      find_servers_for_task(current_task).each do |server|
        run "cd #{current_path};#{rails_env} script/delayed_job #{args_per_host_role server.host,role} restart", :hosts => server.host
      end
    end
  end
end