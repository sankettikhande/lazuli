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

  task :configure_if_needed, :roles => :app do
    puts "Checking config file"
    unless File.exists?("#{shared_path}/config/#{rails_env.downcase}.sphinx.conf")
      sphinx.configure_and_symlink
      #thinking_sphinx.configure
    end
  end

  task :configure_and_symlink, :roles => :app do 
    thinking_sphinx.configure
    run "mv #{current_path}/config/#{rails_env.downcase}.sphinx.conf #{shared_path}/config/#{rails_env.downcase}.sphinx.conf"
  end

  task :symlink_sphinx_config, :roles => :app do
    run "ln -nfs #{shared_path}/config/#{rails_env.downcase}.sphinx.conf #{current_path}/config/#{rails_env.downcase}.sphinx.conf"
  end
end


before "sphinx:configure_and_index", "sphinx:symlink_ts_yml"
before "sphinx:symlink_ts_yml", "thinking_sphinx:configure"
before "sphinx:symlink_sphinx_config", "sphinx:configure_if_needed"
after "sphinx:symlink_ts_yml", "thinking_sphinx:index"
before "thinking_sphinx:index", "sphinx:symlink_sphinx_config"
after "sphinx:setup_ts_yml", "sphinx:symlink_ts_yml"


