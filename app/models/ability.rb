class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.is?(:admin)
      can :manage, :all
    elsif user.is?(:user)
      can [:create, :read], :all
      can [:update, :destroy], Activity, user_id: user.id
      can [:update, :destroy], Venue, created_by: user.id
    else#guest
      can :read, :all
    end
  end
end
