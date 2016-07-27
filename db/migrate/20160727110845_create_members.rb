class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.integer :source_id
      t.string :source_type
      t.references :user, foreign_key: true
      t.string :type

      t.timestamps
    end
  end
end
