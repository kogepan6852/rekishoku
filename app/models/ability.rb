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
    if user
      ## Admin権限
      if user.role == 0
        can :manage, :all
      ## ライター権限
      elsif user.role == 2 || user.role == 3
        can :manage, Feature
        can :manage, FeatureDetail
        can :read, Category
        can :read, Shop
        can :read, ExternalLink
        can :read, Post
        can :access, :rails_admin
        can :dashboard
      end
    end

    # API用アクセスコントロール
    can :read, :api_post
    can :relation, :api_post
    can :manage, :api_post if user && user.role != 1

    can :read, :api_post_detail
    can :manage, :api_post_detail if user && user.role != 1

    can :read, :api_posts_shop
    can :manage, :api_posts_shop if user && user.role != 1

    can :read, :api_people_post
    can :manage, :api_people_post if user && user.role != 1

    can :read, :api_user
    can :manage, :api_user if user && user.role != 1

    can :read, :api_favorite if user
    can :manage, :api_favorite if user

    can :read, :api_favorite_detail if user
    can :manage, :api_favorite_detail if user

  end
end
