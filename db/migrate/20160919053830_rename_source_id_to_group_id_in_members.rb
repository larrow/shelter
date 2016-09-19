class RenameSourceIdToGroupIdInMembers < ActiveRecord::Migration[5.0]
  def change
    rename_column :group_members, :source_id, :group_id
  end
end
