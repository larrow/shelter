class RemoveTypeInMembers < ActiveRecord::Migration[5.0]
  def change
    remove_column :group_members, :type, :string
  end
end
