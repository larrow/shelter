class RemoveRepositoryNameFromRepositoryTeams < ActiveRecord::Migration[5.0]
  def change
    remove_column :repository_teams, :repository_name, :string
  end
end
