set :app_requirements, ['mysql', 'sphinx', 'imagemagick', 'nginx']

namespace :requirements do
  desc "Check required softwares are installed"
  task :check do
    util_bin_map = {:sphinx => 'indexer', :imagemagick => 'identify'}
    missing_requirments = []
    puts app_requirements
    app_requirements.each do |r|
      requirement_path = capture "which #{util_bin_map[r.to_sym] || r}"
      missing_requirments << "'#{r}' is not installed" if requirement_path.nil?
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