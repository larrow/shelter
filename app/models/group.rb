class Group < Namespace
  has_many :group_members, dependent: :destroy
  alias_method :members, :group_members
  has_many :users, through: :group_members
  has_many :owners, -> { where(group_members: { access_level: :owner })}, through: :group_members, source: :user
  has_many :developers, -> { where(group_members: { access_level: :developers })}, through: :group_members, source: :user
  has_many :viewers, -> {where(group_members: { access_level: :viewer })}, through: :group_members, source: :user

  def add_user(user, access_level, current_user = nil)
    GroupMember.add_user(self.group_members, user, access_level, current_user)
  end
end
