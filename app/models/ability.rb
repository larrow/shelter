class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, :all if user.admin?

    # read: view repository
    # write: update/delete repository
    # pull/push: for private registry
    can [:pull,:read], Repository do |repo|
      repo.is_public? || repo.namespace.users.include?(user)
    end
    can [:push,:write], Repository do |repo|
      repo.namespace.owners.include?(user) || repo.namespace.developers.include?(user)
    end

    can :read, Namespace do |ns|
      ns.users.include? user
    end
    can :write, Namespace do |ns|
      ns.owners.include?(user)
    end
  end
end
