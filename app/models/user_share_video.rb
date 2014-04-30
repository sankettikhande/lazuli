class UserShareVideo < ActiveRecord::Base
  attr_accessible :user_id, :video_id, :course_id, :starts_on, :ends_on, :u_token, :topic_id, :title, :duration, :email, :no_of_allowable_views,
:no_of_time_viewed, :video_title
	validates_presence_of :duration, :message => '^Days to allow cant be blank.'
	validates_presence_of :no_of_allowable_views, :message => '^No of views to allow cant be blank.'
  
  def self.token_validity?(token)
  	usv = UserShareVideo.find_by_u_token(token)
  	usv && usv.ends_on > Date.today && usv.no_of_views_remaining > 0
  end

  def no_of_views_remaining
  	self.no_of_allowable_views - self.no_of_time_viewed
  end

  def self.sphinx_search options, current_user
    sphinx_options, search_options, sort_options,select_option = {}, {}, {},{}
    options[:sSearch] = options[:sSearch].gsub(/([_@#!%()\-=;><,{}\~\[\]\.\/\?\"\*\^\$\+\-]+)/, ' ')
    query = options[:sSearch].blank? ? "" : "#{options[:sSearch]}*"
    page = (options[:iDisplayStart].to_i/options[:iDisplayLength].to_i) + 1
    sort_column_direction = [options["mDataProp_#{options[:iSortCol_0]}"], options[:sSortDir_0]].join(" ")
    sort_options.merge!(:order => sort_column_direction)
    sort_options.deep_merge!(:conditions =>{:user_id => current_user.id})
    sphinx_options.merge!(sort_options).merge!(select_option).merge!(search_options)      
    if options[:sSearch_1] == 'all' && !options[:sSearch].blank?
      condition_string = "@(video_title,email) #{options[:sSearch]}*"
      sphinx_options.merge!(:match_mode => :extended)
      UserShareVideo.search(condition_string, sphinx_options).page(page).per(options[:iDisplayLength])
    else      
      sphinx_options.deep_merge!(:conditions => {options[:sSearch_1] => "#{options[:sSearch]}*"}) if !options[:sSearch_1].blank? and !options[:sSearch].blank?      
      UserShareVideo.search(query, sphinx_options).page(page).per(options[:iDisplayLength])        
    end
  end
end


