Rack::MiniProfiler.config.skip_paths << "/assets/"
Rack::MiniProfiler.config.skip_paths << "/favicon.ico"
Rack::MiniProfiler.config.authorization_mode = :whitelist if %w(production staging).include? Rails.env