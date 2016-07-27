class RepositoryMember < Member
  SOURCE_TYPE = 'Repository'

  belongs_to :repository, class_name: 'Repository', foreign_key: 'source_id'

  default_value_for :source_type, SOURCE_TYPE
  validates_format_of :source_type, with: /\ARepository\z/
  default_scope { where(source_type: SOURCE_TYPE) }

  scope :in_repository, ->(repository) { where(source_id: repository.id) }

  def owner?(user)
    repository.owner == user
  end
end
