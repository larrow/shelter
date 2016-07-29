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
      repo.is_public? || repo.namespace.owner == user || repo.namespace&.users&.include?(user) || repo.users.include?(user)
    end
    can [:create, :push], Repository do |repo|
      repo.owner == user || repo.namespace&.users&.include?(user) || usres.include?(user)
    end
    can :update, Repository do |repo|
      repo.owner == user || repo.group&.owners&.include?(user)
    end
    can [:read, :create, :update], Namespace, owner: user
    can [:read, :create, :update], Group do |group| group.owners.include? user end
    can :read, Namespace
    can :read, Group
    can :manage, GroupMember do |group_member|
      group_member.group.owners.include? user
    end
    can :manage, RepositoryMember do |repository_member|
      repository_member.repository.namespace.owner == user || (repository_member.repository.group && repository_member.repository.group.owners.include?(user))
    end
  end
end
