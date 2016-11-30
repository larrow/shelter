class ChangeOwnerToCreator < ActiveRecord::Migration[5.0]
  def change
    rename_column :namespaces, :owner_id, :creator_id
  end
end
