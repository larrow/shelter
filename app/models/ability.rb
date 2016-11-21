class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, :all if user.admin?

    # Repository:
    #   read: can pull, get info from repository
    #   create: can create repo in the namespace
    #   push: can push & create repo in the namespace
    #   update: can change repository's collaborators
    can :read, Repository do |repo|
      repo.is_public? || repo.namespace&.users&.include?(user)
    end
    can [:create, :push, :delete], Repository do |repo|
      repo.namespace&.owners&.include?(user) || repo.namespace&.developers&.include?(user)
    end

    can [:read, :create, :update], Namespace do |ns|
      ns.owners.include?(user)
    end
    can :read, Namespace do |ns|
      ns.users.include? user
    end
  end
end
