class RepositoryTeam < ApplicationRecord
  belongs_to :team
  validates_format_of :repository_name, with: /^[\/a-zA-Z0-9_\.-]*$/, multiline: true
  enum role: { admin: 0, write: 1, read: 2 }
end
