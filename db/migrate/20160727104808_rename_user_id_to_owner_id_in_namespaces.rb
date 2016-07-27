class RenameUserIdToOwnerIdInNamespaces < ActiveRecord::Migration[5.0]
  def change
    rename_column :namespaces, :user_id, :owner_id
  end
end
