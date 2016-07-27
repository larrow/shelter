class Group < Namespace
  has_many :group_members, dependent: :destroy, as: :source, class_name: 'GroupMember'
  alias_method :members, :group_members
  has_many :users, through: :group_members
  has_many :owners, -> { where(members: { access_level: :owner })}, through: :group_members, source: :user

  def add_user(user, access_level, current_user = nil)
    Member.add_user(self.group_members, user, access_level, current_user)
  end
end
