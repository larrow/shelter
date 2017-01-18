class CreateImageTags < ActiveRecord::Migration[5.0]
  def change
    create_table :image_tags do |t|
      t.string :name
      t.string :digest
      t.integer :repository_id

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        drop_table :registry_events
      end
      dir.down do
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
  end
end
