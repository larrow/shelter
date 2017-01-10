class CreateImageTags < ActiveRecord::Migration[5.0]
  def change
    create_table :image_tags do |t|
      t.string :name
      t.string :digest
      t.integer :repository_id

      t.timestamps
    end

    add_column :registry_events, :digest, :string
    add_column :registry_events, :tag_name, :string
  end
end
