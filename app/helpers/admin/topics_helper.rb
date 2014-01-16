module Admin::TopicsHelper
	def video_title(title)
		title.present? ? title : "Add Video"
	end

	def add_topic_title
		request.fullpath.include?("edit") ? "Edit Topic" : "Add Topic"
	end

	def topic_actions(topic)
		action_str = topic_edit_action(topic)
		action_str << topic_delete_action(topic)
		action_str << publish_topic_action(topic)
		action_str.html_safe
	end

	def topic_album_url(topic)
		link_to(topic.vimeo_album_url, topic.vimeo_album_url).html_safe if !topic.vimeo_album_id.nil?
	end

	def publish_topic_action(topic)
    if topic.published?
      link_to(raw_field('fa fa-cloud-upload'), "#", :class => "btn-trans disabled", :rel=>"tooltip", :title=>"Topic Already Published")
    elsif topic.inprocess?
      link_to(raw_field('fa fa-cloud-upload'), "#", :class => "btn-trans inprocess", :rel=>"tooltip", :title=>"Topic Publishing InProcess")
    else
      link_to(raw_field('fa fa-cloud-upload'), "#{admin_topic_path(topic)}?Publish=Publish", :method => :put, :class => "btn-trans", :rel=>"tooltip", :title=>"Publish Topic" )
    end     
  end

  def edit_topic_link topic
    link_to "<i class='fa fa-edit'></i>".html_safe, edit_admin_topic_url(topic), :class => 'btn-trans pull-right',  "data-no-turbolink" => 'true',  :rel => 'tooltip', :title => 'Edit Topic'
  end

  def topic_name_with_edit_link topic
    "<p class='pull-left width90'>#{topic.title}</p>" + edit_topic_link(topic)
  end

  def topic_edit_action(topic)
  	topic.inprocess? ? "<a href='#' class='btn-trans disabled' data-no-turbolink='true' rel='tooltip' title='Edit Topic'><i class='fa fa-edit'></i></a>" : "<a href='/admin/topics/#{topic.id}/edit' class='btn-trans' data-no-turbolink='true' rel='tooltip' title='Edit Topic'><i class='fa fa-edit'></i></a>"
  end

  def topic_delete_action(topic)
  	topic.inprocess? ? "<a href='#' class='btn-trans disabled' rel='tooltip' title='Delete Topic'><i class='fa fa-ban'></i></a>" : "<a href='/admin/topics/#{topic.id}' class='btn-trans' data-method='delete' data-confirm='Are you sure you want to delete?' rel='tooltip' title='Delete Topic'><i class='fa fa-ban'></i></a>"
  end
end
