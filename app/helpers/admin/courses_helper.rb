module Admin::CoursesHelper
  def course_actions course
    link_to(link_raw_field('fa fa-edit'), edit_admin_course_path(course), :rel=>'tooltip', :title => 'Edit Course Details', :class=>'btn-trans', :data =>{'no-turbolink'=>'true'}) << link_to(link_raw_field('fa fa-ban'), admin_course_path(course), :rel=>'tooltip', :title => 'Delete Course', :class=>'btn-trans', :data =>{'no-turbolink'=>'true', :method => 'delete', :confirm => 'Are you sure you want to delete?'})
  end

  def course_title channel
  	channel.courses.count.eql?(1) ? "Course" : "Courses"
  end
end
