class Repository < ApplicationRecord
  belongs_to :namespace

  validates :name, format: /\A[a-zA-Z0-9_\.-]*\z/, presence: true, length: { in: 1..30 }
  default_value_for :pull_count, 0

  class << self
    def sync_from_registry
      Registry.new(is_system: true).repositories.each { |repo_name| find_or_create_by_repo_name(repo_name) }
    end

    def find_or_create_by_repo_name(repo_name)
      namespace = Namespace.find_or_create_by(name: repo_name.split('/').length == 2 ? repo_name.split('/')[0] : 'library')
      namespace.repositories.find_or_create_by(name: repo_name.split('/').length == 2 ? repo_name.split('/')[1] : repo_name)
    end
  end
end
