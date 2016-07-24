class RemoveTeamAuth < ActiveRecord::Migration[5.0]
  def change
    drop_table :repository_teams
    drop_table :teams_users
    drop_table :teams
  end
end
