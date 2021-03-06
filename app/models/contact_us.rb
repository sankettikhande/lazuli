class ContactUs < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :email, :subject, :message  
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, :unless => Proc.new {|c| c.email.blank?}
  validates :name, :subject, :email, :message, :presence => true  
  
  def self.admin_inbox_count current_user
    if current_user.is_admin?
      ContactUs.where(:viewed => false).count
    end 
  end

  def created_time
    self.created_at.to_s
  end

  def self.sphinx_search options, current_user,user_ids=[]
    sphinx_options, search_options, sort_options,select_option = {}, {}, {},{}
    options[:sSearch] = options[:sSearch].gsub(/([_@#!%()\-=;><,{}\~\[\]\.\/\?\"\*\^\$\+\-]+)/, ' ')
    query = options[:sSearch].blank? ? "" : "#{options[:sSearch]}*"
    page = (options[:iDisplayStart].to_i/options[:iDisplayLength].to_i) + 1
    sort_column_direction = [options["mDataProp_#{options[:iSortCol_0]}"], options[:sSortDir_0]].join(" ")
    sort_options.merge!(:order => sort_column_direction)
    # sort_options.deep_merge!(:order => "created_time desc" )
    # sort_options.merge!(:sort_mode => :extended)
    sphinx_options.merge!(sort_options).merge!(select_option).merge!(search_options)
    if current_user.is_admin?       
	    if options[:sSearch_1] == 'all' && !options[:sSearch].blank?
	      condition_string = "@(name,email,subject) #{options[:sSearch]}*"
	      sphinx_options.merge!(:match_mode => :extended)
	      ContactUs.search(condition_string, sphinx_options).page(page).per(options[:iDisplayLength])
	    else    	
	      sphinx_options.deep_merge!(:conditions => {options[:sSearch_1] => "#{options[:sSearch]}*"}) if !options[:sSearch_1].blank? and !options[:sSearch].blank?     	
	      ContactUs.search(query, sphinx_options).page(page).per(options[:iDisplayLength])        
	    end
    end
  end

end
