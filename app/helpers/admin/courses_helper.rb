module Admin::CoursesHelper
	def destroy_Action course
		if can? :destroy, course
		  link_to(link_raw_field('fa fa-ban'), admin_course_path(course), :rel=>'tooltip', :title => 'Delete Course', :class=>'btn-trans', :data =>{'no-turbolink'=>'true', :method => 'delete', :confirm => 'Are you sure you want to delete?'})
		else
			link_to(link_raw_field('fa fa-ban'), '#', :disabled => true, :rel=>'tooltip', :title => 'Delete Course', :class=>'btn-trans', :disabled => true, :data =>{'no-turbolink'=>'true', :method => 'delete', :confirm => 'Are you sure you want to delete?'})
		end
	end
  def course_actions course
    link_to(link_raw_field('fa fa-edit'), edit_admin_course_path(course), :rel=>'tooltip', :title => 'Edit Course Details', :class=>'btn-trans', :data =>{'no-turbolink'=>'true'}) << destroy_Action(course)
  end

  def course_title channel
  	'course'.pluralize(channel.courses.count).titleize
  end
end
