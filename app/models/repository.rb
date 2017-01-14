class Repository < ApplicationRecord
  include Larrow

  belongs_to :namespace
  has_many :tags, class_name: ImageTag

  validates :name, format: /\A[a-zA-Z0-9_\.-]*\z/, presence: true, length: { in: 1..30 }
  validates :namespace, presence: true
  default_value_for :pull_count, 0
  default_value_for :is_public do |repo|
    repo.namespace.default_publicity
  end

  before_save :update_description_html, if: :description_changed?
  before_destroy :clear_tags

  def remove_tag tag_name
    tags.find_by(name: tag_name)&.delete
    delete if tags.empty?
    Registry.delete_tag(full_path, tag_name)
  end

  def clear_tags
    tags.each do |tag|
      Registry.delete_tag(full_path, tag.name)
    end
  end

  def full_path
    namespace.name + '/' + name
  end

  def update_description_html
    self.description_html = GitHub::Markup.render('README.markdown', description)
  end

  class << self
    include Larrow

    def find_or_create_by_full_name(repo_name)
      namespace = Namespace.find_by(name: repo_name.split('/').length == 2 ? repo_name.split('/')[0] : 'library')
      repository = namespace.repositories.find_or_create_by(name: repo_name.split('/').last, deleted_at: nil)
      repository
    end

    def find_by_full_name full_name
      ns_name, repo_name = full_name.split('/')
      if repo_name.nil?
        repo_name = ns_name
        ns_name = 'library'
      end

      namespace = Namespace.find_by(name: ns_name)
      return nil if namespace.nil?

      namespace.repositories.find_by(name: repo_name, deleted_at: nil)
    end
  end

end
