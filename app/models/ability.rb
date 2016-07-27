class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, :all if user.admin?
    can [:read, :create, :update], Repository do |repo|
      repo.namespace.owner == user || repo.namespace&.users&.include?(user)
    end
    can [:read], Repository, is_public: true
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
