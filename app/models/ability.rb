class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, :all if user.admin?
    can [:read, :create, :update], Repository, namespace: { user: user }
    can [:read], Repository, is_public: true
    can [:read, :create, :update], Namespace, user: user
    can [:read], Namespace
  end
end
