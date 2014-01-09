module Admin::TopicsHelper
	def video_title(title)
		title.present? ? title : "Add Video"
	end

	def add_topic_title
		request.fullpath.include?("edit") ? "Edit Topic" : "Add Topic"
	end

	def topic_actions(topic)
		action_str = "<a href='/admin/topics/#{topic.id}/edit' class='btn btn-trans' data-no-turbolink='true' rel='tooltip' title='Edit Topic'><i class='fa fa-edit'></i></a>"
		action_str << "<a href='/admin/topics/#{topic.id}' class='btn btn-trans' data-method='delete' data-confirm='Are you sure you want to delete?' rel='tooltip' title='Delete Topic'><i class='fa fa-ban'></i></a>"
		action_str << link_to(raw_field('fa fa-cloud-upload'), "#{admin_topic_path(topic)}?Publish=Publish", :method => :put, :class => "btn btn-trans", :rel=>"tooltip", :title=>"Publish Topic" ) if !topic.published?
		action_str.html_safe
	end
end
