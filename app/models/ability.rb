class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, :all if user.admin?
    can [:read, :create, :update], Repository, namespace: { user: user }
    can [:read], Repository, is_public: true
    can [:read, :create, :update], Namespace, user: user
    can [:read], Namespace
    can :manage, GroupMember do |group_member|
      group_member.group.owners.include? user
    end
    can :manage, RepositoryMember do |repository_member|
      repository_member.repository.namespace.owner == user || (repository_member.repository.group && repository_member.repository.group.owners.include?(user))
    end
  end
end
