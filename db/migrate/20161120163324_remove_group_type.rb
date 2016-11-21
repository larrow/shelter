class RemoveGroupType < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        remove_column :namespaces, :type
      end

      dir.down do
        add_column :namespaces, :type, :string
      end
    end

    rename_table :group_members, :members
    rename_column :members, :group_id, :namespace_id
  end
end
