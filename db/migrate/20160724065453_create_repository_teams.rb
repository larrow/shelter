class CreateRepositoryTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :repository_teams do |t|
      t.string :repository_name
      t.references :team, foreign_key: true
      t.integer :role

      t.timestamps
    end
  end
end
