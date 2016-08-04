class Member < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true

  validates :user, presence: true
  validates :source, presence: true
  validates :user_id, uniqueness: { scope: [:source_type, :source_id], message: 'already exists in source', allow_nil: true }

  delegate :name, :username, :email, to: :user, prefix: true

  enum access_level: { owner: 0, member: 1 }
  default_value_for :access_level, :member

  def real_source_type
    source_type
  end

  def self.add_user(members, user, access_level, current_user = nil)

    member = members.find_or_initialize_by(user: user)

    # There is no current user for some actions, in which case anything is allowed
    if !current_user || current_user.can?(:update, member.source)
      member.access_level = access_level
      member.save
    end
  end
end
