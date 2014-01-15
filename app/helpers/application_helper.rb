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

  def button_raw_field(classes)
    content_tag(:button, content_tag(:i, '', class: classes), class: 'btn')
  end

  def link_raw_field(classes)
    content_tag(:i, '', class: classes)
  end   
end
