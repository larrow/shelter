class CreateRegistryEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :registry_events do |t|
      t.string :original_id
      t.string :action
      t.string :repository
      t.string :actor

      t.timestamps
    end
    add_index :registry_events, :original_id, unique: true
  end
end
