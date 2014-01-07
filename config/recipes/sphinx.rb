namespace :sphinx do
  desc "Generates thinking_sphinx.yml"
  task :setup_ts_yml, :roles => :app do
    ts_config = <<-EOF
      #{rails_env.downcase}:
          port: 3320
          address: 127.0.0.1
          mem_limit: 256M
          morphology: stem_en
          enable_star: true
          min_infix_len: 0
          min_prefix_len: 1
          searchd_file_path: "#{current_path}/sphinx/index/"
          query_log_file: "#{current_path}/log/searchd.query.log"
          searchd_log_file: "#{current_path}/log/searchd.log"
          pid_file: "#{current_path}/tmp/pids/searchd.pid"
          config_file: "#{current_path}/config/#{rails_env}.sphinx.conf"
          bin_path: '/usr/local/sphinx/bin'

    EOF

    run "mkdir -p #{shared_path}/config"
    put ts_config, "#{shared_path}/config/thinking_sphinx.yml"    
  end

  task :symlink_ts_yml, :roles => :app do
    run "ln -nfs #{shared_path}/config/thinking_sphinx.yml #{current_path}/config/thinking_sphinx.yml"
  end

  task :configure_and_index, :roles => :app do
    put "Configure and create index"
  end
end


before "sphinx:configure_and_index", "sphinx:symlink_ts_yml"
before "sphinx:symlink_ts_yml", "thinking_sphinx:configure"
after "sphinx:symlink_ts_yml", "thinking_sphinx:index"


