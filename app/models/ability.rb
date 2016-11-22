class Ability
  include CanCan::Ability

  def initialize(user)

    if user.nil?
      can :read, Micropost
    elsif user.role == 'admin'
      can :manage, :all
    elsif user.role == 'moderator'
      can :manage, Micropost
      can :manage, Comment
      can :read, :all
      can :ban, User
      can [:update, :destroy], User, id: user.id
    elsif user.role == 'member'
      can :read, :all
      can :create, Micropost
      can :create, Comment
      can [:update, :destroy], Micropost, user_id: user.id
      can [:update, :destroy], User, id: user.id
    end

  end
end