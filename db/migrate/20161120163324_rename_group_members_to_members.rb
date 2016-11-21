class RenameGroupMembersToMembers < ActiveRecord::Migration[5.0]
  def change
    rename_table :group_members, :members
    rename_column :members, :group_id, :namespace_id
  end
end
