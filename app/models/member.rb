class Member < ApplicationRecord

  belongs_to :namespace
  belongs_to :user

  validates :user, presence: true
  validates :user_id, uniqueness: { scope: [:group_id], message: 'already exists in group', allow_nil: true }

  delegate :name, :username, :email, to: :user, prefix: true

  enum access_level: { owner: 0, developer: 1, viewer: 2 }
  default_value_for :access_level, :developer

  def self.add_user(members, user, access_level, current_user = nil)

    member = members.find_or_initialize_by(user: user)

    # There is no current user for some actions, in which case anything is allowed
    if !current_user || current_user.can?(:update, member.group)
      member.access_level = access_level
      member.save
    end
  end

end
