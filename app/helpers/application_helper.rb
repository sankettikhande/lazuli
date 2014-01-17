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

  def link_raw_field(classes)
    content_tag(:i, '', class: classes)
  end

  def add_breadcrumb(options = {})
    default_options = {:separator => ">>"}
    options = default_options.merge(options)
    url = request.fullpath.split("?").first
    crumbs = []
    if ["index"].include? params[:action]
      crumbs << params[:controller].split("/")
      crumbs = crumbs[0]
    elsif ["show", "edit", "new", "new_bulk" ].include? params[:action]
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
      fields.find(id).name
    else
      fields.find(id).title
    end
  end

  def flash_message
    flash_css_classes = {:notice =>"note-info", :success => "note-success", :alert => "note-alert", :error => "note-danger"}
    flash.map do |key, msg|
      content_tag :div, msg, :id => key, :class => "note #{flash_css_classes[key]}"
    end.join.html_safe
  end
end
