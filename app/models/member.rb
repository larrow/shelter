class Member < ApplicationRecord

  belongs_to :namespace
  belongs_to :user

  validates :user, presence: true
  validates :user_id, uniqueness: { scope: [:namespace_id], message: 'already exists in group', allow_nil: true }

  delegate :name, :username, :email, to: :user, prefix: true

  enum access_level: { owner: 0, developer: 1, viewer: 2 }
  default_value_for :access_level, :developer

end
