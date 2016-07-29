class User < ApplicationRecord
  attr_accessor :login
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :authentication_keys => [:login]
  validates :username, format: /\A[a-zA-Z0-9_\.-]*\z/, presence: true, length: { in: 2..30 }, uniqueness: { case_sensitive: false }
  validate :namespace_uniq, if: ->(user) { user.username_changed? }

  has_one :namespace, -> { where type: nil }, foreign_key: :owner_id, class_name: 'Namespace'

  has_many :members, dependent: :destroy
  has_many :group_members, dependent: :destroy, source: 'GroupMember'
  has_many :groups, through: :group_members
  has_many :owned_groups, -> { where members: { access_level: Member.access_levels[:owner] }}, through: :group_members, source: :group

  has_many :groups_repositories, through: :groups, source: :repositories
  has_many :personal_repositories, through: :namespace, source: :repositories
  has_many :repository_members, dependent: :destroy, class_name: 'RepositoryMember'
  has_many :repositories, through: :repository_members

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  after_save :ensure_namespace_correct
  def ensure_namespace_correct
    self.create_namespace!(name: self.username) unless self.namespace

    self.namespace.update_attributes(name: self.username) if self.username_changed?
  end

  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, to: :ability

  def namespace_uniq
    return if self.errors.key?(:username) && self.errors[:username].include?('has already been taken')

    existing_namespace = Namespace.find_by(name: self.username)
    self.errors.add(:username, 'has already been token') if existing_namespace && existing_namespace != self.namespace
  end

  def create_group(group_name)
    group = Group.create(name: group_name)
    group.add_user(self, :owner)
    group
  end

  def create_personal_repository(repo_name)
    ensure_namespace_correct
    repo = self.namespace.repositories.find_or_create_by(name: repo_name)
    repo.add_user(self, :owner)
    repo
  end

  def authorized_groups
    union = union_to_sql([groups.select(:id), authorized_repositories.select(:namespace_id)])
    Group.where("namespaces.id IN (#{union})")
  end


  def authorized_repositories
    Repository.where("repositories.id IN (#{repositories_union})")
  end

  private

  def repositories_union
    relations = [personal_repositories.select(:id), groups_repositories.select(:id), repositories.select(:id)]
    union_to_sql(relations)
  end
end
