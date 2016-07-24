class CreateTeamsUsersJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_table :teams_users do |t|
      t.references :user, index: true
      t.references :team, index: true
    end
  end
end
