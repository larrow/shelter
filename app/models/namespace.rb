class Namespace < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :repositories, after_add: :post_to_namespace_channel
  validates :name, presence: true, uniqueness: true
  validates :name, format: /\A[a-zA-Z.0-9_\-]+\z/, length: { in: 2..30 }

  has_many :members, dependent: :destroy
  has_many :users, through: :members

  has_many :owners,     -> { where(group_members: { access_level: :owner     })}, through: :members, source: :user
  has_many :developers, -> { where(group_members: { access_level: :developer })}, through: :members, source: :user
  has_many :viewers,    -> { where(group_members: { access_level: :viewer    })}, through: :members, source: :user

  def add_user(user, access_level, current_user = nil)
    GroupMember.add_user(self.members, user, access_level, current_user)
  end

  protected

  def post_to_namespace_channel(repository)
    NamespaceChannel.broadcast_to(self, action: 'new_repository', content: ApplicationController.render(repository)) if repository.id # ignore initialize
  end
end
