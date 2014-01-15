module Admin::TopicsHelper
	def video_title(title)
		title.present? ? title : "Add Video"
	end

	def add_topic_title
		request.fullpath.include?("edit") ? "Edit Topic" : "Add Topic"
	end

	def topic_actions(topic)
		action_str = "<a href='/admin/topics/#{topic.id}/edit' class='btn-trans' data-no-turbolink='true' rel='tooltip' title='Edit Topic'><i class='fa fa-edit'></i></a>"
		action_str << "<a href='/admin/topics/#{topic.id}' class='btn-trans' data-method='delete' data-confirm='Are you sure you want to delete?' rel='tooltip' title='Delete Topic'><i class='fa fa-ban'></i></a>"
		action_str << publish_action(topic)
		action_str.html_safe
	end

	def topic_album_url(topic)
		link_to(topic.vimeo_album_url, topic.vimeo_album_url).html_safe if !topic.vimeo_album_id.nil?
	end

	def publish_action(topic)
    if topic.published?
      link_to(raw_field('fa fa-cloud-upload'), "#", :class => "btn-trans disabled", :rel=>"tooltip", :title=>"Already Published Topic")
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
end
