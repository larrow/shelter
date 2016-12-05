class Repository < ApplicationRecord
  belongs_to :namespace

  validates :name, format: /\A[a-zA-Z0-9_\.-]*\z/, presence: true, length: { in: 1..30 }
  validates :namespace, presence: true
  default_value_for :pull_count, 0
  default_value_for :is_public do |repo|
    repo.namespace.default_publicity
  end

  before_save :update_description_html, if: :description_changed?
  before_destroy :clear_tags

  def tags
    registry.tags&.map do |tag|
      {
        name: tag,
        size: JSON.parse(registry.manifests(tag)[1])['layers'].reduce(0) { |size, layer| size + layer['size'] }
      }
    end || []
  end

  def clear_tags
    registry.tags&.map do |tag|
      registry.delete_tag(tag)
    end
  end

  def full_path
    namespace.name + '/' + name
  end

  def update_description_html
    self.description_html = GitHub::Markup.render('README.markdown', description)
  end

  class << self
    def sync_from_registry
      repositories = Registry.new().repositories
      Repository.transaction do
        repositories.each do |repo|
          registry = Registry.new(repository: repo)
          if registry.tags
            find_or_create_by_repo_name repo
          else
            namespace = Namespace.find_by(name: repo.split('/').length == 2 ? repo.split('/')[0] : 'library')
            namespace&.repositories&.where(name: repo.split('/').last)&.each { |r| r.destroy }
          end
        end
      end
    end

    def find_or_create_by_repo_name(repo_name)
      namespace = Namespace.find_by(name: repo_name.split('/').length == 2 ? repo_name.split('/')[0] : 'library')
      repository = namespace&.repositories&.find_or_create_by(name: repo_name.split('/').last, deleted_at: nil)
      repository
    end
  end

  # 无状态的对象可以反复使用
  def registry
    @registry ||= Registry.new(repository: full_path)
  end
end
