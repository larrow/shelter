class Team < ApplicationRecord
  belongs_to :namespace
  has_and_belongs_to_many :users
  has_many :repository_teams
  enum role: { owner: 0, collaborator: 1 }
end
