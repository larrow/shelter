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
    tag = tags.find_by(name: tag_name)
    tag.delete if tag
    Registry.delete_tag(full_path, tag_name)
  end

  def try_to_delete
    delete if Registry.tags(full_path).empty?
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

    def find_or_create_by_repo_name(repo_name)
      namespace = Namespace.find_by(name: repo_name.split('/').length == 2 ? repo_name.split('/')[0] : 'library')
      repository = namespace&.repositories&.find_or_create_by(name: repo_name.split('/').last, deleted_at: nil)
      repository
    end
  end

end
