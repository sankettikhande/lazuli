class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    
    can [:manage], User do |u|
      u == user
    end

    if user.is_admin?
        can :manage, :all
    elsif user.is_channel_admin?
        can :manage, UserChannelSubscription do |ucs|
            user.subscribed_course_ids.include?(ucs.course_id)
        end
        can :manage, Course do |course| 
            course.channel_admin_user_id == user.id || course.course_admin_user_id == user.id
        end
        can :manage, Channel, :admin_user_id => user.id
        can [:get_channel,:channel_courses], Channel
        can :manage, Topic do |topic| 
            topic.channel_admin_user_id == user.id || topic.course_admin_user_id == user.id
        end
        can :manage, User do |u|
            u.created_by == user.id || user.administrated_channel_subscriber_ids.include?(u.id)
        end
        cannot :destroy, User do |u|
         u.created_by != user.id && user.administrated_channel_subscriber_ids.include?(u.id)
        end
        can :manage, Video do |video| 
            video.channel_admin_user_id == user.id || video.course_admin_user_id == user.id
        end

        can :show, Video do |video|
            video.channel_admin_user_id == user.id || video.course_admin_user_id == user.id || user.watchable_video?(video, video.topic.course_id)
        end
        can :create, [Topic,Video,Course,User]
        can :manage, UserChannelSubscription do |ccp|
            user.administrated_channel_ids.include?(ccp.channel_id) || user.administrated_course_ids.include?(ccp.course_id)
        end
        cannot :create, Channel
    elsif user.is_course_admin?
        can :manage, UserChannelSubscription do |ucs|
            user.subscribed_course_ids.include?(ucs.course_id)
        end
        can :manage, Course, :course_admin_user_id => user.id
        can :manage, Topic, :course_admin_user_id => user.id
        can :manage, Video, :course_admin_user_id => user.id
        can :show, Video do |video|
            video.course_admin_user_id == user.id || user.watchable_video?(video, video.topic.course_id)
        end
        can [:get_channel,:channel_courses], Channel
        cannot :create, [Course,User,Channel]
        can :create, [Topic, Video]
    else
        can :search, :all
        can :show, Video do |video|
            user.watchable_video?(video, video.topic.course_id)
        end
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
