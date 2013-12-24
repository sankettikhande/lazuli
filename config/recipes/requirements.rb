namespace :requirements do
  desc "Check required softwares are installed"
  task :check do
    util_bin_map = {:sphinx => 'indexer'}
    missing_requirments = []

    app_requirements.each do |r|
      requirement_path = `which #{util_bin_map[r] || r}`
      missing_requirments << "'#{r}' is not installed" if requirement_path.strip.empty?  
    end
    if missing_requirments.empty?
      logger.info "========== ALL GOOD !!! ALL REQUIRED SOFTWARES ARE INSTALLED ========="
    else
      logger.info "xxxxxxxxx WARNING !!! FOLLOWING PACKAGES ARE NOT INSTALLED ON #{rails_env} SERVER xxxxxxxxx"
      missing_requirments.each_with_index do |message, index|
        logger.info "#{index + 1}). #{message}"
      end
      abort("Please install above installed packages on #{rails_env} server and try again")
    end
  end
end