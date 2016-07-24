class AddRepositoryIdToRepositoryTeams < ActiveRecord::Migration[5.0]
  def change
    add_reference :repository_teams, :repository, foreign_key: true
  end
end
