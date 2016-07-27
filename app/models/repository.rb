class Repository < ApplicationRecord
  belongs_to :namespace
  belongs_to :group, -> { where(type: 'Group') }, foreign_key: 'namespace_id'

  has_many :repository_members, dependent: :destroy, as: :source, class_name: 'RepositoryMember'
  alias_method :members, :repository_members
  has_many :users, through: :repository_members

  delegate :owner, to: :namespace

  validates :name, format: /\A[a-zA-Z0-9_\.-]*\z/, presence: true, length: { in: 1..30 }
  validates :namespace, presence: true
  default_value_for :pull_count, 0
  default_value_for :is_public, -> { namespace.default_publicity }

  def tags
    registry = Registry.new(is_system: true, repository: full_path)
    registry.tags&.map do |tag|
      {
        name: tag,
        size: JSON.parse(registry.manifests(tag)[1])['layers'].reduce(0) { |size, layer| size + layer['size'] }
      }
    end || []
  end

  def full_path
    namespace.name + '/' + name
  end

  def add_user(user, access_level , current_user = nil)
    Member.add_user(self.repository_members, user, access_level, current_user)
  end

  class << self
    def sync_from_registry
      Registry.new(is_system: true).repositories.each { |repo_name| find_or_create_by_repo_name(repo_name) }
    end

    def find_or_create_by_repo_name(repo_name)
      namespace = Namespace.find_by(name: repo_name.split('/').length == 2 ? repo_name.split('/')[0] : 'library')
      repository = namespace.repositories.find_or_create_by(name: repo_name.split('/').length == 2 ? repo_name.split('/')[1] : repo_name)
      repository.add_user(namespace.owner, :owner) if namespace.type.nil?
      repository
    end
  end
end
