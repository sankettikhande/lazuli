module ApplicationHelper
	def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
  def errors_for resource
    error_message_tag resource.errors.full_messages
  end

  def error_message_tag error_messages
    if(error_messages.present?)
      errors_ul = content_tag(:ul)  do
        error_messages.collect {|error_msg| concat(content_tag(:li, error_msg))}
      end
      content_tag(:div, errors_ul, :class => "small_alert error devise_errors", :style=>'color: #FF0000;')
    end
  end

  def sortable(column)
    direction = column == params[:sort_column] && params[:direction] == "desc" ? "asc" : "desc"
    link_to '', {:sort_column => column, :direction => direction}, {:class => 'fa fa-3x fa-filter pull-right', :id => 'column_sort_css'}
  end

  def lazuli_button_to(title, href, options={})
    classes = "btn btn-block #{options[:class]}"
    content_tag(:button, :type => "button", :data =>{:href => href}, :class => classes ) do
      title
    end
  end

  def required_field
    content_tag(:span, :class => "required_span") do
      "*"
    end
  end

  def raw_field(classes, title=nil)
    content_tag(:i, '', class: classes) << " #{title}"
  end

  def button_raw_field(classes, button_classes="btn")
    content_tag(:button, content_tag(:i, '', class: classes), class: button_classes)
  end

  def button_field(classes, button_classes="btn", title)
    content_tag(:button, class: button_classes) do
      content_tag(:i, '', class: classes) << " #{title}"
    end
  end

  def link_image_tag(image)
    content_tag(:div, class: "play-overlay") do
     image_tag(video_thumbnail_image(image, :medium => true), :alt => 'image', :class => "img-responsive center-block yellow-shadow") << content_tag(:div,'', :class => "play-btn")
    end 
  end  

  def link_raw_field(classes)
    content_tag(:i, '', class: classes)
  end

  def random_time
    Time.now.to_i + rand(100000)
  end

  def add_breadcrumb(options = {})
    default_options = {:separator => ">>"}
    options = default_options.merge(options)
    url = request.fullpath.split("?").first
    url.gsub!('new','Add Single user') if url == '/admin/users/new'
    url.gsub!('new_bulk','Add Multiple users') if url == '/admin/users/new_bulk'
    crumbs = []
    if ["index"].include? params[:action]
      crumbs << params[:controller].split("/")
      crumbs = crumbs[0]
    elsif ["show", "edit", "new", "new_bulk", "update", "create"].include? params[:action]
      crumbs += url.split("/")
    end
    crumbs = crumbs.delete_if(&:blank?)
    crumbs_urls = []
    if crumbs.present?
      crumbs.each do |i|
        crumbs_urls << "#{crumbs_urls.last}/#{i}"
      end
    end
    build_breadcrumbs(crumbs, crumbs_urls, options)
  end

  def build_breadcrumbs(crumbs, crumbs_urls, options = {})
    breadcrumb_array = []
    content_tag :div, :id => "breadcrumbs" do
      crumbs.uniq.each_with_index do |c, i|
        if(crumbs.last == c)
          breadcrumb_array << "<span id='list_set_#{i}' class='breadcrumb'>#{c.to_s.titleize}</span>"
        elsif(c =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/)
          breadcrumb_array << "<span id='list_set_#{i}' class='breadcrumb'>#{set_title_for_id(crumbs[1], c)}</span>"
        elsif(["topics", "videos", "courses"].include?(c))
          breadcrumb_array << "<span id='list_set_#{i}' class='breadcrumb #{c}'><a>#{c.to_s.titleize}</a></span>"
        else
          breadcrumb_array << "<span id='list_set_#{i}' class='breadcrumb '><a href='#{crumbs_urls[i]}' data-no-turbolink=true>#{c.to_s.titleize}</a></span>"
        end
      end
    end
    breadcrumb_array.join(options[:separator]).html_safe
  end

  def set_title_for_id(fields, id)
    fields = fields.capitalize.singularize.constantize
    if(fields != Topic)
      fields.find(id).name.truncate(60)
    else
      fields.find(id).title.truncate(60)
    end
  end

  def courses_breadcrumbs(resource, resource_video, options = {})
    default_options = {:separator => ">>"}
    options = default_options.merge(options)
    url = request.fullpath.split("?").first
    crumbs = []
    crumbs += url.split("/")
    crumbs = crumbs.delete_if(&:blank?)
    crumbs_list = ["courses"]
    if(crumbs.length == 3)
      course_name = resource.name
      video_name = resource_video.title
      topic_name = resource_video.topic.title
    else
      course_name = resource.name
      topic_name = resource.topics.first.title
      video_name = resource_video.title
    end
    crumbs_list << course_name << topic_name << video_name
    crumbs_list_array(crumbs_list, crumbs, resource, resource_video, options)
  end

  def crumbs_list_array crumbs_list, crumbs, resource, resource_video, options
    breadcrumb_array = []
    content_tag :div, :id => "breadcrumbs" do
      crumbs_list.each_with_index do |crumb, index|
        if((crumbs_list.last == crumb) && (index == crumbs_list.length-1))
          breadcrumb_array << "<span id='list_set_#{index}' class='breadcrumb'>#{crumb.to_s.titleize}</span>"
        elsif(crumbs_list.first == crumb)
          breadcrumb_array << "<span id='list_set_#{index}' class='breadcrumb'><a href='#' data-no-turbolink=true>#{crumb.to_s.titleize}</a></span>"
        else
          breadcrumb_array << "<span id='list_set_#{index}' class='breadcrumb'><a href='/#{courses_crumbs_urls(crumbs, index, resource, resource_video)}' data-no-turbolink=true>#{crumb.to_s.titleize}</a></span>"
        end
      end
    end
    breadcrumb_array.join(options[:separator]).html_safe
  end

  def courses_crumbs_urls(crumbs, index, resource, resource_video)
    url_array = ["courses"]
    cour_id = crumbs[1]
    url_array << cour_id
    if(index == 1)
      url_array << resource.topics.published.first.try(:videos).try(:first).try(:id)
    else
      url_array << resource_video.topic.videos.first.id
    end
    url_array.join("/")
  end

  def flash_message
    flash_css_classes = {:notice =>"note-info", :success => "note-success", :alert => "note-warning", :error => "note-danger"}
    flash.map do |key, msg|
      content_tag :div, msg, :id => key, :class => "note #{flash_css_classes[key]}"
    end.join.html_safe
  end

  def background_color
    "brush lemon" if !(controller_name == "courses" && action_name == "show")
  end

  def courses_breadcrumbs1(course, topic, video)
    link_arr = []
    link_arr << "<ol class='breadcrumb'><li>" + link_to("Courses", "") + "</li>"
    link_arr << "<li>" + link_to(course.name.titleize.truncate(25) , course_video_url(course.id)) + "</li>"
    link_arr << "<li>" + link_to(topic.title.titleize.truncate(25) , course_topic_url(course.id, video.topic_id)) + "</li>"
    link_arr << "<li class='active'>" + video.title.titleize.truncate(25) + "</li></ol>"
    link_arr.join(" ").html_safe
  end

  def displaying_videos_thumbnail(source)
    if source.is_a?(Course)
      video_to_display = source.course_first_video
      link_to(link_image_tag(video_to_display), course_topic_video_path(source.id, video_to_display.topic.id, video_to_display.id)) if video_to_display
    elsif source.is_a?(Topic)
      video_to_display = source.topic_first_video
      link_to(link_image_tag(video_to_display), course_topic_video_path(source.course_id, source.id, video_to_display.id)) if video_to_display
    end
  end
end
