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