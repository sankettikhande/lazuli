module WideSearch
	class << self
		def search_suggestions options
	    sort_options, search_options, sphinx_options, select_option = {}, {}, {}, {}
	    options[:sSearch] = options[:sSearch].gsub(/([_@#!%()\-=;><,{}\~\[\]\.\/\?\"\*\^\$\+\-]+)/, ' ')
	    sphinx_options.merge!(search_options).deep_merge!(:conditions => {options[:sSearch_1] => "#{options[:sSearch]}*", :channel_type => "public", :status => "published"}, :include => [:course, :channel]) 
	    sphinx_options.merge!(:classes => [Course,Topic,Video])
	    ThinkingSphinx.search(sphinx_options)
	  end

		def search_results query
			filter_options, sql_options = {}, {}
			query_string = query.gsub(/([_@#!%()\-=;><,{}\~\[\]\.\/\?\"\*\^\$\+\-]+)/, ' ')
			options = {:star => true, :match_mode => :extended}
			search_string = "@(title,description) #{query_string}*"
			filter_options.merge!(:conditions => {:status => "published"})
			filter_options.deep_merge!(:conditions => {:channel_type => "public"})
			# sql_options.merge!(:sql => {:include => [:channel, :topics]})

			sort_options = {:sort_mode =>  :extended, :order => :custom_model_sort}
			options.merge!(filter_options).merge!(sql_options).merge!(:classes => [Course, Topic, Video]).merge!(sort_options)
			ThinkingSphinx.search(search_string, options)
		end
	end
end