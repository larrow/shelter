class GroupMember < Member
  SOURCE_TYPE = 'Namespace'

  belongs_to :group, class_name: 'Group', foreign_key: 'source_id'

  default_value_for :source_type, SOURCE_TYPE
  validates_format_of :source_type, with: /\ANamespace\z/
  default_scope { where(source_type: SOURCE_TYPE) }

  def group
    source
  end

  def real_source_type
    'Group'
  end
end
