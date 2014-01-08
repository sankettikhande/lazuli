namespace :sphinx do
  desc "Generates thinking_sphinx.yml"
  task :setup_ts_yml, :roles => :app do
    ts_config = <<-EOF
      #{rails_env.downcase}:
          mem_limit: 256M
          morphology: stem_en
          enable_star: true
          min_infix_len: 0
          min_prefix_len: 1
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
after "sphinx:setup_ts_yml", "sphinx:symlink_ts_yml"


