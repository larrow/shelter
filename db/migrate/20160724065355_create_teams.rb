class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.references :namespace, foreign_key: true
      t.integer :role

      t.timestamps
    end
  end
end
