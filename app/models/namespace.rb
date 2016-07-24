class Namespace < ApplicationRecord
  self.inheritance_column = nil
  belongs_to :user
  has_many :teams
  enum type: { by_user: 0, by_group: 1 }

  after_save :create_owners_team
  def create_owners_team
    owners_team = self.teams.find_or_create_by(name: 'owner', role: :owner)
    owners_team.users << self.user unless owners_team.users.include? self.user
  end
end
