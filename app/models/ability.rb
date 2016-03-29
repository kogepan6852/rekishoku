class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
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
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    # 管理画面用アクセスコントロール
    can :manage, Post, user_id: user.id if user
    can :read, Post

    can :manage, PostDetail, user_id: user.id if user
    can :read, PostDetail

    can :manage, PostsShop, user_id: user.id if user
    can :read, PostsShop

    can :manage, PeoplePost, user_id: user.id if user
    can :read, PeoplePost

    can :manage, :Menu
    cannot :manage ,Shop
    cannot :manage, Person
    cannot :manage, Period

    if user
      if user.role == 1
         can :manage, Shop
         can :manage, Person
         can :manage, Period
      end
      if user.role == 0
        can :manage, :all
      end
    end

    # API用アクセスコントロール
    can :read, :api_post
    can :relation, :api_post
    can :manage, :api_post if user

    can :read, :api_post_detail
    can :manage, :api_post_detail if user

    can :read, :api_posts_shop
    can :manage, :api_posts_shop if user

    can :read, :api_people_post
    can :manage, :api_people_post if user

    can :read, :api_user
    can :manage, :api_user if user

  end
end
