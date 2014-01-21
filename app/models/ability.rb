class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.is_admin?
        can :manage, :all
    elsif user.is_channel_admin?
        can :manage, Course do |course| 
            course.channel_admin_user_id == user.id || course.course_admin_user_id == user.id
        end
        can :manage, Channel, :admin_user_id => user.id
        can :manage, Topic do |topic| 
            topic.channel_admin_user_id == user.id || topic.course_admin_user_id == user.id
        end
        can :manage, User, :created_by => user.id
        can :manage, Video do |video| 
            video.channel_admin_user_id == user.id || video.course_admin_user_id == user.id
        end
        can :create, [Topic,Video,Course,User]
        cannot :create, Channel
    elsif user.is_course_admin?
        can :manage, Course, :course_admin_user_id => user.id
        can :manage, Topic, :course_admin_user_id => user.id
        can :manage, Video, :course_admin_user_id => user.id
        cannot :create, [Course,User,Channel]
        can :create, [Topic, Video]
    else
        can :search, :all
    end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
