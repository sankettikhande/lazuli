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